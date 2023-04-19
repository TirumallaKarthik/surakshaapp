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
    String name;
    int age;
    String description;
    var coordinates;
    var adoptedby;
    var reportedby;
    var imageurl;
    Orphanobject(this.name,this.age,this.description,this.coordinates,this.adoptedby,this.reportedby,this.imageurl);
}