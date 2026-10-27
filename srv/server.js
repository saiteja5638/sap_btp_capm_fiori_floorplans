const cds = require("@sap/cds");
const crypto = require("crypto");
const axios = require("axios");
const cov2ap = require("@cap-js-community/odata-v2-adapter");
const cookieParser = require("cookie-parser");

const { google } = require("googleapis");


// const GOOGLE_CLIENT_ID = "553407028295-5sdo6jgmkemgusi655fjrhhnt1lt2a2r.apps.googleusercontent.com";

// const GOOGLE_CLIENT_SECRET = "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";

// const GOOGLE_REDIRECT_URI = "https://d6b1e8dbtrial-dev-sample2-srv.cfapps.us10-001.hana.ondemand.com/auth/google/callback";


const oauth2Client = new google.auth.OAuth2(
    GOOGLE_CLIENT_ID,
    GOOGLE_CLIENT_SECRET,
    GOOGLE_REDIRECT_URI
);


cds.on("bootstrap", async (app) => {
    app.use(cookieParser());
    app.use(cov2ap());
    app.get("/auth/google", async (req, res) => {

        const state =
            crypto.randomBytes(32).toString("hex");


        res.cookie(
            "google_oauth_state",
            state,
            {
                httpOnly: true,
                secure:
                    process.env.NODE_ENV === "production",
                sameSite: "lax"
            }
        );


        const authUrl =
            oauth2Client.generateAuthUrl({

                access_type: "offline",

                scope: [
                    "openid",
                    "email",
                    "profile"
                ],

                state: state

            });


        console.log(
            "Redirecting to Google..."
        );


        res.redirect(authUrl);
    });
    app.get("/auth/google/callback", async (req, res) => {

        try {

            const {
                code,
                state
            } = req.query;


            // ----------------------------------
            // Validate state
            // ----------------------------------

            // if (!state ||state !==req.cookies.google_oauth_state) {

            //     return res
            //         .status(400)
            //         .send(
            //             "Invalid OAuth state"
            //         );
            // }


            // if (!code) {

            //     return res
            //         .status(400)
            //         .send(
            //             "Authorization code missing"
            //         );
            // }


            // ----------------------------------
            // Exchange code for tokens
            // ----------------------------------

            const { tokens } = await oauth2Client.getToken(code);


            oauth2Client.setCredentials(tokens);


            // ----------------------------------
            // Get Google profile
            // ----------------------------------

            const oauth2 =
                google.oauth2({
                    auth: oauth2Client,
                    version: "v2"
                });


            const { data } = await oauth2.userinfo.get();

            // ----------------------------------
            // Your user object
            // ----------------------------------

            const user = {

                googleId: data.id,

                email: data.email,

                name: data.name,

                firstName: data.given_name,

                lastName: data.family_name,

                picture: data.picture,

                verifiedEmail:
                    data.verified_email

            };


        } catch (error) {

            console.error(
                "Google OAuth Error:",
                error
            );


            res
                .status(500)
                .send(
                    "Google authentication failed"
                );
        }

    }
    );
    app.get("/auth/github", (req, res) => {

        const clientId = "Ov23liz0adfLRxwu3nth";

        const redirectUri = "https://d6b1e8dbtrial-dev-sample2-srv.cfapps.us10-001.hana.ondemand.com/auth/github/callback";

        const githubUrl =
            "https://github.com/login/oauth/authorize" +
            `?client_id=${clientId}` +
            `&redirect_uri=${encodeURIComponent(redirectUri)}` +
            `&scope=user:email`;

        res.redirect(githubUrl);
    });
    app.get("/auth/github/callback", async (req, res) => {

        console.log("================================");
        console.log("GITHUB CALLBACK HIT");
        console.log("================================");

        try {

            const { code } = req.query;

            if (!code) {
                return res.status(400).send(
                    "Authorization code missing"
                );
            }

            console.log("1. GitHub authorization code received");

            // Exchange authorization code for access token
            const tokenResponse = await axios.post(
                "https://github.com/login/oauth/access_token",
                {
                    client_id: "Ov23liz0adfLRxwu3nth",
                    client_secret: "bbea26b452b8e05c0817ba0a3cd0139a220ecbfa",
                    code: code,
                    redirect_uri: "https://d6b1e8dbtrial-dev-sample2-srv.cfapps.us10-001.hana.ondemand.com/auth/github/callback"
                },
                {
                    headers: {
                        Accept: "application/json"
                    }
                }
            );

            const accessToken =
                tokenResponse.data.access_token;

            if (!accessToken) {
                throw new Error(
                    "GitHub access token not received"
                );
            }

            console.log("2. GitHub access token received");

            // Get GitHub user
            const userResponse = await axios.get(
                "https://api.github.com/user",
                {
                    headers: {
                        Authorization: `Bearer ${accessToken}`,
                        Accept: "application/vnd.github+json"
                    }
                }
            );

            const githubUser = userResponse.data;

            console.log("3. GitHub user received");

            // // Get verified email
            // const emailResponse = await axios.get(
            //     "https://api.github.com/user/emails",
            //     {
            //         headers: {
            //             Authorization: `Bearer ${accessToken}`,
            //             Accept: "application/vnd.github+json"
            //         }
            //     }
            // );

            // const emails = emailResponse.data;

            // const primaryEmail =
            //     emails.find(
            //         email =>
            //             email.primary &&
            //             email.verified
            //     );

            // console.log("4. GitHub email received");

            return res.json({
                success: true,

                user: {
                    githubId: githubUser.id,
                    username: githubUser.login,
                    name: githubUser.name,
                    picture: githubUser.avatar_url,
                    profile: githubUser.html_url
                }
            });

        } catch (error) {

            console.error(
                "GITHUB OAUTH ERROR"
            );

            console.error(
                error.response?.data ||
                error.message
            );

            return res.status(500).json({
                success: false,
                error:
                    error.response?.data ||
                    error.message
            });
        }
    });

});


module.exports = cds.server;
