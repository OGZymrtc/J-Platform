class Logicalreff{
  int logicalRef;
  int ok = 0 ;

  Logicalreff({this.logicalRef, this.ok});

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["logicalRef"] = logicalRef;
    map["ok"] = ok;
    return map;
  }

  Logicalreff.fromMAp(Map<String, dynamic> map){
        this.logicalRef = map['logicalRef'];
        this.ok = map['ok'];
  }


  @override
  String toString() {
    return 'Logicalreff{logicalRef: $logicalRef, ok: $ok}';
  }
}