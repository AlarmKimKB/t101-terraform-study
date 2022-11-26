resource "aws_kms_key" "scott_cmk" {
  policy = data.aws_iam_policy_document.cmk_admin_policy.json
}

resource "aws_kms_alias" "scott_cmk" {
  name          = "alias/cmk-scott"
  target_key_id = aws_kms_key.scott_cmk.id
}