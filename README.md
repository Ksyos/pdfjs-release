# PDF.js Node Module

This is the [prebuilt release](https://mozilla.github.io/pdf.js/getting_started/#download) from Mozilla's PDF.js repackaged as a node module. Only package metadata is added and the viewer controls for presentation mode, opening another file, and the current bookmark are hidden with a small CSS patch.

To update and publish, run:

```
npm run update
# or npm run update:win on Windows (Git Bash / MSYS bash required)
npm pack
npm publish
```

**Warning**

Before upgrading this package in ClientSafe, please, do make sure the PDF viewer in ClientSafe works fine on [a feature branch](https://ksyos-it.atlassian.net/wiki/spaces/IT/pages/2863529985/Feature+test+environments), since it will mostly always work on local develop. For the sake of employing good practices, do **avoid** using `'unsafe-eval'` on the CSP.
