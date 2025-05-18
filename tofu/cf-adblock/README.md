```shell
# Initialize tofu
tofu init -backend-config="prefix=cf-adblock/$(git rev-parse --abbrev-ref HEAD)"
```
