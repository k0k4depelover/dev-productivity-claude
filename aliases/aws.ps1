# ============================================================
#  Aliases — AWS CLI
# ============================================================

# ── Perfil activo ────────────────────────────────────────────
function aws-profile    { $env:AWS_PROFILE = $args[0]; Write-Host "→ Perfil: $env:AWS_PROFILE" -ForegroundColor Green }
function aws-whoami     { aws sts get-caller-identity }
function aws-region     { $env:AWS_DEFAULT_REGION = $args[0]; Write-Host "→ Región: $env:AWS_DEFAULT_REGION" -ForegroundColor Green }

# ── EC2 ──────────────────────────────────────────────────────
function ec2-list       { aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress,Tags[?Key=='Name'].Value|[0]]" --output table }
function ec2-start      { param($id) aws ec2 start-instances --instance-ids $id }
function ec2-stop       { param($id) aws ec2 stop-instances --instance-ids $id }
function ec2-ssh        { param($ip, $key) ssh -i $key "ec2-user@$ip" }

# ── S3 ───────────────────────────────────────────────────────
function s3-ls          { aws s3 ls $args }
function s3-cp          { param($src, $dst) aws s3 cp $src $dst }
function s3-sync        { param($src, $dst) aws s3 sync $src $dst }
function s3-mb          { param($b) aws s3 mb "s3://$b" }
function s3-rb          { param($b) aws s3 rb "s3://$b" --force }

# ── ECS / ECR ────────────────────────────────────────────────
function ecr-login      {
    $region = $env:AWS_DEFAULT_REGION ?? "us-east-1"
    $account = (aws sts get-caller-identity --query Account --output text)
    aws ecr get-login-password --region $region | docker login --username AWS --password-stdin "$account.dkr.ecr.$region.amazonaws.com"
}
function ecs-list       { aws ecs list-clusters }
function ecs-services   { param($c) aws ecs list-services --cluster $c }

# ── Lambda ───────────────────────────────────────────────────
function lambda-list    { aws lambda list-functions --query "Functions[*].[FunctionName,Runtime,LastModified]" --output table }
function lambda-invoke  { param($fn, $payload) aws lambda invoke --function-name $fn --payload $payload /tmp/lambda_out.json; cat /tmp/lambda_out.json }
function lambda-log     { param($fn) aws logs tail "/aws/lambda/$fn" --follow }

# ── CloudWatch Logs ──────────────────────────────────────────
function cwlog-groups   { aws logs describe-log-groups --query "logGroups[*].logGroupName" --output table }
function cwlog-tail     { param($g) aws logs tail $g --follow }

# ── Secrets Manager ─────────────────────────────────────────
function secret-get     { param($name) aws secretsmanager get-secret-value --secret-id $name --query SecretString --output text }
function secret-list    { aws secretsmanager list-secrets --query "SecretList[*].Name" --output table }

# ── SSM Parameter Store ──────────────────────────────────────
function ssm-get        { param($path) aws ssm get-parameter --name $path --with-decryption --query Parameter.Value --output text }
function ssm-list       { param($path="/") aws ssm get-parameters-by-path --path $path --recursive --query "Parameters[*].Name" --output table }
