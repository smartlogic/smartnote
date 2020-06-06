# SmartNote

SmartNote is an app to track internal documentation, starting with FAQs around development.

## Local Development

In order to run locally, you'll need a `.env.dev` file with the following filled in:

```
GITHUB_ALLOWED_ORGANIZATIONS=comma,separated,list,of,github,orgs
GITHUB_CLIENT_ID=...
GITHUB_CLIENT_SECRET=...
```

Create a GitHub OAuth application and copy the client id and secret. Make sure the authorized redirect uri is `http://localhost:4000/auth/github/callback`.

## Kubernetes

To migrate on kubernetes, find a pod and exec into it and run this:

```bash
smart_note eval "SmartNote.ReleaseTasks.Migrate.run()"
```
