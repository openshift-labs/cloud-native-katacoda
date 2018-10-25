When building deployment pipelines, it's important to treat your [infrastructure and everything else that needs to be configured (including the pipeline definition) as code](https://martinfowler.com/bliki/InfrastructureAsCode.html)
and store them in a source repository for version control.

Commit and push the **Jenkinsfile** to the Git repository.

```
git add Jenkinsfile
```{{execute}}

```
git commit -m "pipeline added"
```{{execute}}

```
git push origin master
```{{execute}}

Enter your Git credentials if asked. The pipeline definition is 
ready and now you can create a deployment pipeline using
this **Jenkinsfile**.
