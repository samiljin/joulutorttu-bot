sam package --template-file template.yaml --output-template-file packaged-template.yaml --s3-bucket joulutorttu-bot

sam deploy --template-file packaged-template.yaml --stack-name joulutorttu-bot --capabilities CAPABILITY_IAM