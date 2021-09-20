import 'package:creativedata_app/Enum/viewState.dart';
import 'package:flutter/cupertino.dart';
/*
* Created by Mujuzi Moses
*/

class ImageUploadProvider with ChangeNotifier {

  ViewState _viewState = ViewState.IDLE;
  ViewState get getViewState => _viewState;

  void setToLoading() {
    _viewState = ViewState.LOADING;
    notifyListeners();
  }

  void setToIdle() {
    _viewState = ViewState.IDLE;
    notifyListeners();
  }
}