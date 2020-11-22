class ResumeDetails {
  final String resumeId, fname, lname, phoneNumber, address, education, skills, projects;

  ResumeDetails(
      {this.resumeId, this.fname, this.lname, this.phoneNumber, this.address, this.education, this.skills, this.projects
      });

  Map toMap(ResumeDetails map) {
    var data = <String, dynamic>{};
    data['resumeId'] = map.resumeId;
    data['fname'] = map.fname;
    data['lname'] = map.lname;
    data['phoneNumber'] = map.phoneNumber;
    data['address'] = map.address;
    data['education'] = map.education;
    data['skills'] = map.skills;
    data['projects'] = map.projects;
    return data;
  }

}
