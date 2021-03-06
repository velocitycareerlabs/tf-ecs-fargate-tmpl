name                = "vcl"
environment         = "sheridan"
cidr                = "10.0.0.0/16"
availability_zones  = ["us-east-1b", "us-east-1d"]
private_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets      = ["10.0.128.0/24", "10.0.129.0/24"]
health_check_path   = "/"
tls_certificate_arn = "arn:aws:acm:us-east-1:589446945997:certificate/7050b753-e712-4d6e-ad7d-4bc53951b839"
common_service_vars = [
  {name = "NODE_ENV", value = "dev"},
  {name = "LOG_SEVERITY", value = "debug"},
  {name = "HOST", value = "0.0.0.0"},
  {name = "PORT", value = "3000"},
  {name = "VNF_PUBLIC_KEY_ID", value = "did:ethr:0x7c98a6cea317ec176ba865a42d3eae639dfe9fb1#key-1"},
  {name = "ADMIN_USER_NAME", value = "velocity.admin@example.com"}
]
services            = {
  mockvendor = {
    vars = [
      {name = "MONGO_URI", value = "mongodb+srv://admin:SoaO_38Tje62ChxuRib8@vcl-t6mwr.mongodb.net/mockvendor-sheridan?retryWrites=true&w=majority"},
    ],
    secretMap = {SECRET: "SECRET"}
  }
  oracle = {
    vars = [
      {name = "MONGO_URI", value = "mongodb+srv://admin:SoaO_38Tje62ChxuRib8@vcl-t6mwr.mongodb.net/oracle-sheridan?retryWrites=true&w=majority"},
      {name = "RPC_NODE_URL", value = "http://34.244.131.79:8547"},
      {name = "CONTRACT_ADDRESS", value = "0xf49e283837D11C7c18Fb6176C29ecc3d2B2b97F9"},
      {name = "ROOT_DID", value = "did:ethr:0x7c98a6cea317ec176ba865a42d3eae639dfe9fb1"},
      {name = "ROOT_ADDRESS", value = "0x7c98a6cea317ec176ba865a42d3eae639dfe9fb1"},
      {name = "ROOT_KID", value = "did:ethr:0x7c98a6cea317ec176ba865a42d3eae639dfe9fb1#key-1"},
      {name = "ROOT_PRIVATE_KEY", value = "5592ca0adbe0899fe3e9b50cb1a411750bc7220c900f30d176bc7bd8d4ec68e9"},
      {name = "VERIFICATION_SENDER_EMAIL", value = "verify@velocitycareerlabs.com"},
      {name = "AWS_REGION", value = "us-east-1"}
    ],
    secretMap = {SECRET: "SECRET", MONGO_SECRET: "MONGO_SECRET", AWS_ACCESS_KEY_ID: "SNS_AWS_ACCESS_KEY_ID", AWS_SECRET_KEY: "SNS_AWS_SECRET_KEY"}
  },
  credagent = {
    vars = [
      {name = "MONGO_URI", value = "mongodb+srv://admin:SoaO_38Tje62ChxuRib8@vcl-t6mwr.mongodb.net/credagent-sheridan?retryWrites=true&w=majority"},
      {name = "RPC_NODE_URL", value = "http://34.244.131.79:8547"},
      {name = "CONTRACT_ADDRESS", value = "0xf49e283837D11C7c18Fb6176C29ecc3d2B2b97F9"},
      {name = "VENDOR_URL", value = "https://sheridanmockvendor.velocitycareerlabs.io"}
    ],
    secretMap = {SECRET: "SECRET", MONGO_SECRET: "MONGO_SECRET"}
  }
  verifagent = {
    vars = [
      {name = "MONGO_URI", value = "mongodb+srv://admin:SoaO_38Tje62ChxuRib8@vcl-t6mwr.mongodb.net/verifagent-sheridan?retryWrites=true&w=majority"},
      {name = "RPC_NODE_URL", value = "http://34.244.131.79:8547"},
      {name = "CONTRACT_ADDRESS", value = "0xf49e283837D11C7c18Fb6176C29ecc3d2B2b97F9"},
      {name = "VENDOR_URL", value = "https://sheridanservices.velocitycareerlabs.io/api/v0.6/verify"}
    ],
    secretMap = {SECRET: "SECRET", MONGO_SECRET: "VERIFAGENT_MONGO_SECRET"}
  }
}