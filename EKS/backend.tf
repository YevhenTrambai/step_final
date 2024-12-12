terraform {
  backend "s3" {
    bucket         = "danit-devops-tf-state"
    # Example
    #key            = "eks/terraform.tfstate"
    key            = "yevhent/terraform.tfstate"
    encrypt        = true
    # Example
    #dynamodb_table = "lock-tf-eks"
    dynamodb_table = "lock-tf-step-final-yevhent"
    # dynamo key LockID
    # Params tekan from -backend-config when terraform init
    #region = 
    #profile = 
  }
}

