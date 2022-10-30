## Summary
This script creates a custom scope in Webstorm from a git diff. The resulting scope contains only changes between the current branch and a desired comparison branch, usually `develop`. This can be useful to see code inspection results only for new changes. 

After generating the scope, navigate to Webstorm's code inspection and select `custom scope` -> `inspectionDiff`.
Note that the generated scope will always be named `inspectionDiff`.

## Usage

1. Run install.sh to add the command `diffscope` to your /usr/local/bin path via symlink.
1. Source your terminal profile or restart your terminal to see the command. 
1. Navigate to any git project with an existing Webstorm project. 
1. Ensure that at least one scope already exists in the project. If not, create a new scope through the webstorm interface.
1. Run the command `diffscope`. The script will prompt you for further inputs. 

### Troubleshooting

__ERROR: Failed to add scope, ScopeManager doesn't exist__

If Webstorm doesnt have any defined scopes, the script doesnt know where to add a new scope. To fix, create a new scope in webstorm and run the script again.

