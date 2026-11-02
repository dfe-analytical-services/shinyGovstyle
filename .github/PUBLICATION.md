# Publishing the website and showcase

| Workflow | When it runs | Website | Showcase branch |
| --- | --- | --- | --- |
| Publish development | Push to main | `/shinyGovstyle/dev/` | `deploy/showcase-dev` |
| Publish CRAN | Manual run from main | `/shinyGovstyle/` | `deploy/showcase-cran` |

Updating one version leaves the other unchanged. Pull requests do not publish
anything. Never merge the generated branches into main.

## Publish a CRAN release

Open **Actions → Publish CRAN → Run workflow**, select **main**, and enter:

| Input | What to enter |
| --- | --- |
| `source_sha` | The release commit's full 40-character ID (SHA) |
| `cran_version` | The shinyGovstyle version already on CRAN, such as `0.3.0` |

Use the commit used for the CRAN release. Its DESCRIPTION version must match
`cran_version`. The website uses that commit; the showcase uses the CRAN package.
This does not submit a package to CRAN.

## If something goes wrong

If the workflow fails, open its run in **GitHub Actions** and check the failed step.

Connect updates separately. Check the showcase after publishing; if it does not
work, ask your Connect administrator to check its logs.

Retry the latest development run or run **Publish CRAN** again. Choosing an older
CRAN release replaces the current one. Rebuilding may use newer dependencies.
