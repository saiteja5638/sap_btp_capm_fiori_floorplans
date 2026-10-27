const cds = require('@sap/cds');
const axios = require('axios');


module.exports = async srv => {

    srv.on('createSchedulerJob', async (req) => {
        try {

            const credentials = getJobSchedulerCredentials();

            const token = await getToken(credentials);
 
            const job = {
                name: data.jobName,
                description: data.description,

                action: data.endpoint,

                active: true,

                schedule: {
                    cron: data.schedule
                }
            };

            const response = await axios.post(
                `${credentials.url}/scheduler/jobs`,
                job,
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                        'Content-Type': 'application/json'
                    }
                }
            );

        } catch (error) {
            console.log(error.message)
        }
    })

}


function getJobSchedulerCredentials() {

    const vcap = JSON.parse(
        process.env.VCAP_SERVICES || '{}'
    );

    const services = vcap.jobscheduler || [];

    if (!services.length) {
        throw new Error(
            'Job Scheduler service binding not found'
        );
    }

    return services[0].credentials;
}

async function getToken(credentials) {

    const response = await axios.post(
        credentials.uaa.url + '/oauth/token',
        new URLSearchParams({
            grant_type: 'client_credentials'
        }),
        {
            auth: {
                username: credentials.uaa.clientid,
                password: credentials.uaa.clientsecret
            },
            headers: {
                'Content-Type':
                    'application/x-www-form-urlencoded'
            }
        }
    );

    return response.data.access_token;
}
