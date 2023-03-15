# PDF.js Node Module

This is the [prebuilt release](https://mozilla.github.io/pdf.js/getting_started/#download) from Mozilla's PDF.js repackaged as a node module. Only a `package.json` is added and the buttons to open the bookmarks, to open another file and presentation mode are removed.

To update and publish, run:

```
npm run update
npm publish
```

**Warning**

Before upgrading this package in ClientSafe, please, do make sure the PDF viewer in ClientSafe works fine on [a feature branch](https://ksyos-it.atlassian.net/wiki/spaces/IT/pages/2863529985/Feature+test+environments), since it will mostly always work on local develop. For the sake of employing good practices, do **avoid** using `'unsafe-eval'` on the CSP.
