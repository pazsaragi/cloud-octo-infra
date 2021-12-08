# Infra Repo


* Frontend -> nextjs
* Backend -> Django or FastAPI?
* Database -> Postgres
* VSC -> Git -> CodeCommit
* CI -> CodeBuild, CodePipeline
* CD -> CodeDeploy

## CI/CD

* CodeCommit: A managed git repo. We’ll check our terraform code into a repo hosted in Codecommit. Enough said.
* CodeBuild: A managed continuous integration service. It runs job definitions, dynamically spins up and down build servers, and can support your own tooling, i.e. terraform! We’ll write a deploy terraform build in CodeBuild.
* CodeDeploy: A managed deployment service that helps push code from a repo to AWS services where it can be executed. This is the only CodeX service from AWS we won’t use.
* CodePipeline: A managed deployment service that supports complex deployment processes including code testing, automated deployment all the way to production. We’ll write a pipeline to automate a PR merge → terraform deploy.