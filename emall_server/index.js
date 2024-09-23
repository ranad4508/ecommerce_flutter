const Flutterwave = require('flutterwave-node-v3');
const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const fetch = require('node-fetch');
const axios = require('axios');
const app = express()
dotenv.config();
app.use(cors());
app.use(express.json());


const flw = new Flutterwave(process.env.FLW_PUBLIC_KEY, process.env.FLW_SECRET_KEY);



app.post('/', async (req, res) => {
    try {
        const response = await flw.Charge.card(req.body)
        console.log(response)
        res.json(response);
        // Authorizing transactions

        // For PIN transactions
        if (response.meta.authorization.mode === 'pin') {
            let payload2 = req.body
            payload2.authorization = {
                "mode": "pin",
                "fields": [
                    "pin"
                ],
                "pin": res.body.pin
            }

            console.log(response);
        }

    } catch (error) {
        console.log(error)
    }



});

app.post('/otp', async (req, res) => {
    try {
        const callValidate = await flw.Charge.validate(req.body)
        res.json(callValidate);
        console.log(callValidate);

    }

    catch (error) {
        console.log(error)
    }



});

app.post('/verify-transaction', async (req, res) => {
    try {

        const transaction = await flw.Transaction.verify(req.body);
        res.json(transaction);
        console.log(transaction);
    }

    catch (error) {
        console.log(error)
    }



});
app.post('/verify-transaction-queue', async (req, res) => {
    try {
        const transaction = transactionVerificationQueue.add(req.body);
        console.log(transaction);
        return res.redirect('/payment-processing');

    }

    catch (error) {
        console.log(error)
    }



});

app.post('/token', async (req, res) => {
    try {

        const token = await flw.Tokenized.charge(req.body);
        res.json(token);
        console.log(token);
    }


    catch (error) {
        console.log(error)
    }



});

app.post('/create-payment-intent', async (req, res) => {
    const {
        email,
        items,
        currency,
        request_three_d_secure,
        payment_method_types = [],
        client = 'ios',
    } = req.body;



    const stripe = new Stripe(process.env.StripeSecretKey, {
        apiVersion: '2023-08-16',
        typescript: true,
    });

    try {
        const customer = await stripe.customers.create({ email });

        const params = {
            amount: req.body.amount * 100,
            currency: req.body.currency,
            customer: customer.id,
            payment_method_options: {
                card: {
                    request_three_d_secure: request_three_d_secure || 'automatic',
                },
                sofort: {
                    preferred_language: 'en',
                },
                wechat_pay: {
                    app_id: 'wx65907d6307c3827d',
                    client: client,
                },
            },
            payment_method_types: payment_method_types,
        };

        const paymentIntent = await stripe.paymentIntents.create(params);

        // Send publishable key and PaymentIntent client_secret to client.
        return res.send({
            clientSecret: paymentIntent.client_secret,
        });
    } catch (error) {
        return res.send({
            error: error.raw.message,
        });
    }
});
app.post('/payment-sheet', async (_, res) => {


    const stripe = new Stripe(process.env.StripeSecretKey, {
        apiVersion: '2023-08-16',
        typescript: true,
    });

    const customers = await stripe.customers.list();

    // Here, we're getting latest customer only for example purposes.
    const customer = customers.data[0];

    if (!customer) {
        return res.send({
            error: 'You have no customer created',
        });
    }

    const ephemeralKey = await stripe.ephemeralKeys.create(
        { customer: customer.id },
        { apiVersion: '2023-08-16' }
    );
    console.log(`Response is ${_.body.amount}`);
    const paymentIntent = await stripe.paymentIntents.create({
        amount: _.body.amount * 100,
        currency: 'eur',
        customer: customer.id,
        // Edit the following to support different payment methods in your PaymentSheet
        // Note: some payment methods have different requirements: https://stripe.com/docs/payments/payment-methods/integration-options
        payment_method_types: [
            'card',
            // 'ideal',
            // 'sepa_debit',
            // 'sofort',
            // 'bancontact',
            // 'p24',
            // 'giropay',
            // 'eps',
            // 'afterpay_clearpay',
            // 'klarna',
            // 'us_bank_account',
        ],
    });
    return res.json({
        paymentIntent: paymentIntent.client_secret,
        ephemeralKey: ephemeralKey.secret,
        customer: customer.id,
    });
});

app.listen(process.env.Port, () => {
    console.log(`Example app listening on port ${process.env.Port}`);
    console.log(process.env.FLW_PUBLIC_KEY);

})