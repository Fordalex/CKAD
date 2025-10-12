# Jobs and CronJobs - CKAD Exam Task

## Task

You need to create batch workloads using Jobs and CronJobs for various automation tasks.

**Scenario:**
Your organization needs to run batch processing tasks and scheduled maintenance jobs. You'll create one-time Jobs for data processing and recurring CronJobs for automated tasks like backups and cleanup.

**Requirements:**

1. Create a namespace named **batch-processing**.

2. Create a Job named **data-import** in the **batch-processing** namespace:
   - Image: **busybox:1.35**
   - Command: Generate a random number and write it to a file, then sleep for 10 seconds
   - Command: `sh -c "echo 'Processing data...' && echo $RANDOM > /tmp/data.txt && cat /tmp/data.txt && sleep 10 && echo 'Data import complete'"`
   - Completions: **3** (job should run 3 times successfully)
   - Parallelism: **2** (run 2 pods in parallel)
   - Backoff limit: **4** (max 4 retries on failure)
   - Restart policy: **Never**

3. Create a Job named **database-migration** in the **batch-processing** namespace:
   - Image: **postgres:14-alpine**
   - Command: `["psql", "--version"]`
   - Completions: **1**
   - TTL after finished: **100** seconds (auto-cleanup)
   - Restart policy: **Never**

4. Create a CronJob named **backup-job** in the **batch-processing** namespace:
   - Schedule: Every 5 minutes (`*/5 * * * *`)
   - Image: **busybox:1.35**
   - Command: `sh -c "echo 'Running backup at $(date)' && sleep 5 && echo 'Backup complete'"`
   - Restart policy: **OnFailure**
   - Concurrency policy: **Forbid** (don't allow overlapping jobs)
   - Successful jobs history: **3**
   - Failed jobs history: **1**

5. Create a CronJob named **cleanup-job** in the **batch-processing** namespace:
   - Schedule: Every day at 2:00 AM (`0 2 * * *`)
   - Image: **busybox:1.35**
   - Command: `sh -c "echo 'Cleaning up old files...' && sleep 3 && echo 'Cleanup complete'"`
   - Restart policy: **Never**
   - Concurrency policy: **Replace** (kill old job if still running)
   - Starting deadline seconds: **60** (if missed by more than 60s, skip)

6. Verify Jobs complete successfully and check their logs.

7. Verify CronJobs are scheduled and create Jobs according to schedule.

8. Manually trigger the **backup-job** CronJob to create a Job immediately.

## Starting Files

- `data-import-job.yaml` - Job template with partial configuration
- `backup-cronjob.yaml` - CronJob template

## Job and CronJob Concepts

**Jobs:**
- Run Pods until successful completion
- Useful for batch processing, migrations, one-time tasks
- Can run multiple completions in parallel or sequentially
- Tracks successful completions

**Job Completion Modes:**
- **Non-parallel**: One Pod runs until completion
- **Parallel with fixed completion count**: N Pods must complete
- **Parallel with work queue**: Pods coordinate completion

**Job Configuration:**
- **completions**: Number of successful completions required
- **parallelism**: Max Pods running concurrently
- **backoffLimit**: Max retries before marking Job failed
- **activeDeadlineSeconds**: Max time Job can run
- **ttlSecondsAfterFinished**: Auto-delete Job after completion

**CronJobs:**
- Create Jobs on a schedule (cron format)
- Useful for backups, reports, maintenance, cleanup
- Based on Kubernetes cluster time (not node time)

**CronJob Schedule Format:**
```
┌───────────── minute (0-59)
│ ┌───────────── hour (0-23)
│ │ ┌───────────── day of month (1-31)
│ │ │ ┌───────────── month (1-12)
│ │ │ │ ┌───────────── day of week (0-6, Sunday=0)
│ │ │ │ │
* * * * *
```

**Concurrency Policies:**
- **Allow**: Allow concurrent Jobs (default)
- **Forbid**: Skip new Job if previous still running
- **Replace**: Cancel old Job and start new one

**CronJob Configuration:**
- **schedule**: Cron expression for schedule
- **successfulJobsHistoryLimit**: Keep N completed Jobs
- **failedJobsHistoryLimit**: Keep N failed Jobs
- **startingDeadlineSeconds**: Latest time to start missed Job
- **suspend**: Pause CronJob (true/false)

## Verification Commands

```bash
# Check Jobs
kubectl get jobs -n batch-processing
kubectl describe job data-import -n batch-processing
kubectl get job data-import -n batch-processing -o yaml

# Check Job Pods
kubectl get pods -n batch-processing
kubectl get pods -n batch-processing --show-labels

# View Job logs
kubectl logs -n batch-processing job/data-import
kubectl logs -n batch-processing -l job-name=data-import

# Check CronJobs
kubectl get cronjobs -n batch-processing
kubectl describe cronjob backup-job -n batch-processing

# View CronJob schedule and status
kubectl get cronjob backup-job -n batch-processing -o yaml

# Manually trigger CronJob
kubectl create job backup-manual --from=cronjob/backup-job -n batch-processing

# Check Jobs created by CronJob
kubectl get jobs -n batch-processing -l parent-cronjob=backup-job

# Watch for new Jobs being created
kubectl get jobs -n batch-processing -w

# Suspend/resume CronJob
kubectl patch cronjob backup-job -n batch-processing -p '{"spec":{"suspend":true}}'
kubectl patch cronjob backup-job -n batch-processing -p '{"spec":{"suspend":false}}'

# Delete completed Jobs
kubectl delete job data-import -n batch-processing
```

## Tips

- Always set `restartPolicy: Never` or `restartPolicy: OnFailure` for Jobs
- Default `restartPolicy: Always` doesn't work with Jobs
- Use `completions` for tasks that need to run N times
- Use `parallelism` to control concurrent executions
- TTL controller automatically cleans up finished Jobs
- CronJob schedule uses UTC timezone
- Use `*/5` for "every 5 minutes", `0 */2` for "every 2 hours"
- Test CronJob schedule with online cron calculators
- Manual trigger: `kubectl create job --from=cronjob/<name>`
- Jobs are immutable - delete and recreate to change

## Time Limit

**22 minutes**
