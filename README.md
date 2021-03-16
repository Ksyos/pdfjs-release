# PDF.js Node Module

This is the [prebuilt release](https://mozilla.github.io/pdf.js/getting_started/#download) from Mozilla's PDF.js repackaged as a node module. No changes are made, only a `package.json` is added.

To update and publish, run:

```
npm run update
npm publish
```

**Warning**

Before performing an upgrade, please, do make sure the PDF file displaying works fine on [a feature branch](https://teams.microsoft.com/l/entity/com.microsoft.teamspace.tab.wiki/tab::ef0dee98-bc2a-4711-8120-64253f16c143?context=%7B%22subEntityId%22%3A%22%7B%5C%22pageId%5C%22%3A16%2C%5C%22origin%5C%22%3A2%7D%22%2C%22channelId%22%3A%2219%3Ae97e3b241c634e1d86657339001d0ab4%40thread.tacv2%22%7D&tenantId=44357375-229c-4283-8035-40cd91d7d7d4), since it will mostly always work on local develop. For the sake of employing good practices, do **avoid** using `'unsafe-eval'` on the CSP.
