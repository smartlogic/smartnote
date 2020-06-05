# SmartNote

SmartNote is an app to track internal documentation, starting with FAQs around development.

## Kubernetes

To migrate on kubernetes, find a pod and exec into it and run this:

```bash
smart_note eval "SmartNote.ReleaseTasks.Migrate.run()"
```
