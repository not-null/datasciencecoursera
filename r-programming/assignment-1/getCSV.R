get_csv_path <- function(csv_path, file_no, id)
{
    if(id[file_no] >= 1 && id[file_no] <= 9)
    {
        file_name <- paste(c(csv_path,id[file_no]),collapse="/00")
    }
    else if(id[file_no] >= 10 && id[file_no] <= 99)
    {
        file_name <- paste(c(csv_path,id[file_no]),collapse="/0")
    }
    else
    {
        file_name <- paste(c(csv_path,id[file_no]),collapse="/") 
    }
    csv_file <- paste(c(file_name,"csv"),collapse=".")
}