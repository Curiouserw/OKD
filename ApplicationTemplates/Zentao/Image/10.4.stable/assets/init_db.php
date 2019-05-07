<?php
$mysql_conf = array(
    'host'    => getenv("MYSQL_HOST"),
    'port'    => getenv("MYSQL_PORT"),
    'db'      => getenv("MYSQL_DB_NAME"),
    'db_user' => getenv("MYSQL_DB_USER"),
    'db_pwd'  => getenv("MYSQL_DB_PASSWD")
    );

$mysqli = mysqli_connect($mysql_conf['host'],$mysql_conf['db_user'],$mysql_conf['db_pwd']);

if (!$mysqli) {
    printf("无法连接到MySQL服务器. Errorcode: %s ", mysqli_connect_error());
    exit;
}else
    printf("Connected to MySQL Server \n") ;
    //从数据库实例中查询所有Databases
    $databases_o = $mysqli->query("show databases");
    //将查询到的结果对象转换为多维数组
    $databases_a = mysqli_fetch_all($databases_o,MYSQLI_NUM);
    
    //判断"zentao"datbase是否存在数据库实例中的Database中，不存在的话，创建数据库Database,执行SQL文件将数据库结构导进去。
    if ( ! deep_in_array('zentao',$databases_a)){
       echo "当前数据库实例中没有${mysql_conf['db']}的Database, 接下会创建${mysql_conf['db']}的Database并导入zentao的表结构\n";
       if ($mysqli->query("CREATE DATABASE zentao") === TRUE) {
         if ( mysqli_select_db($mysqli,'zentao') ){
           echo "${mysql_conf['db']} Database创建成功,并且切换至该Database下，接下来开始导入表结构SQL脚本 \n";
           $sqlfile=file_get_contents('/assets/zentao_schema.sql');
           $sql = explode(';', $sqlfile);
           foreach ($sql as $_value) {
             $mysqli->query($_value.';');  
           }
           $tables_o = $mysqli->query("show tables") ;
           if (($tables_o ->num_rows)  === 57 ){
             echo "zentao数据库表已导入zentao Database中 \n";
           }
         }
       }
    }else {
      echo "当前数据库实例中已经存在Database ${mysql_conf['db']},接下来检查该Database中是否存在zentao的表结构，是否有数据 \n" ;
      mysqli_select_db($mysqli,'zentao');
      if (($mysqli->query("show tables") -> num_rows) === 57){
         echo "Database ${mysql_conf['db']} 已经存在zentao的表结构\n";
      }elseif(($mysqli->query("show tables") -> num_rows) === 0){
         echo "当前数据库实例Database ${mysql_conf['db']}中没有表，将导入zentao的表结构。\n";
         $sqlfile=file_get_contents('/assets/zentao_schema.sql');
         $sql = explode(';', $sqlfile);
         foreach ($sql as $_value) {
           $mysqli->query($_value.';');
         }
         $tables_o = $mysqli->query("show tables") ;
         if (($tables_o ->num_rows)  === 57 ){
           echo "zentao数据库表已导入zentao Database中 \n";
         }
      }
      
    }


//查询多维数组中是否包含某个值
function deep_in_array($value, $array) {
  foreach($array as $item) {
    if(!is_array($item)) {
        if ($item == $value) {
            return true;
        } else {
            continue;
        }
    }
    if(in_array($value, $item)) {
        return true;
    } else if(deep_in_array($value, $item)) {
        return true;
    }
  }
  return false;
}


mysqli_close($mysqli);
?>


