variable Env{
    type = string 
    
}
variable bucket_name{
    type = string 
    
}
variable files{
    type = list(object({
    key    = string
    source = string
   
  }))

}
variable upload_files{
    type = bool

}
variable enable_bucket_versioning{
    type = string
    default = "Enabled"

}