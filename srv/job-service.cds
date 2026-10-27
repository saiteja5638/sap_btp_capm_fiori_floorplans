using model from '../db/model';

@path: '/job'
service JobService {


    entity Jobs          as projection on model.Jobs;

    entity JobExecutions as projection on model.JobExecutions;

    action createSchedulerJob(jobName: String,
                              description: String,
                              endpoint: String,
                              schedule: String) returns Jobs;

    action triggerSchedulerJob(jobId: UUID)     returns String;

    action deleteSchedulerJob(jobId: UUID)      returns String;

}
