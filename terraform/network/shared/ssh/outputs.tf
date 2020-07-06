output "key_pairs" {
  value = {
    shared = {
      key_name    = aws_key_pair.shared.key_name
      key_pair_id = aws_key_pair.shared.key_pair_id
      fingerprint = aws_key_pair.shared.fingerprint
      public_key  = aws_key_pair.shared.public_key
    }
  }
}
