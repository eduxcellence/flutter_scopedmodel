import 'dart:collection';
import 'dart:convert';

import 'package:flutter_scopedmodel/constant/constants.dart';
import 'package:flutter_scopedmodel/model/jobs_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class JobsScopedModel extends Model
{


  List<JobsModel> _jobsListing=[];
  List<JobsModel> get jobsListing => _jobsListing;

  bool _isLoading=false;
  bool get isLoading => _isLoading;


  String _searchString = "";
  UnmodifiableListView<JobsModel> get jobsModel =>
      _searchString.isEmpty
          ? UnmodifiableListView(jobsListing)
          : UnmodifiableListView(
          jobsListing.where((jobsModel) =>
              jobsModel.title.toLowerCase().trim().contains(
                  _searchString.toLowerCase().trim())));

  void changeSearchString(String searchString) {
    _searchString = searchString;
    print(_searchString);
    notifyListeners();
  }


 void fetchJobListing()
  async {
    _isLoading = true;
    _jobsListing = [];
    notifyListeners();


    var data = await http.get(Constants.jobFetchUrl);
    var mapData = jsonDecode(data.body);
    if (data.statusCode == 200) {
      for (Map i in mapData) {
        _jobsListing.add(JobsModel.fromJson(i));
      }
      _isLoading = false;
      notifyListeners();
    }



  }

}