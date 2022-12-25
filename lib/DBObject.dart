class Memberobject {
    String name;
    String state;
    int orphans_reported;
    String type= "member";
    String phonenumber;
    Memberobject(this.name,this.state,this.orphans_reported,this.phonenumber);
}

class Ngoobject {
    String name;
    String state;
    int orphans_adopted;
    String type="ngo";
    String mailid;
    Ngoobject(this.name,this.state,this.orphans_adopted,this.mailid);
}

class Orphanobject {
    String name = "Ramesh";
    int age = 22;
    String description = "He is found lying on road";
    var coordinates = "80 E 30 N";
    var adoptedby = "Ram Seva";
    var reportedby = "Anand";
    var imageurl = "https://picsum.photos/200";
    Orphanobject(this.name,this.age,this.description,this.coordinates,this.adoptedby,this.reportedby,this.imageurl);
}