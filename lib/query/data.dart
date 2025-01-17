class Variables{
  static String payTo="";
  static bool permission=false;
  static Map<String,dynamic> mapTransaction={"payto":"","amount":"","time":"","location":"","status":"","remark":""};
  static String tranStatus="fail";
  static bool registered = false;
  static bool connection = false;
  static Map<String,dynamic> profile={};
  static Map<String,dynamic>transactionHistory={};
  static int index=0;
}