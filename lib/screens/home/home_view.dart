import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/screens/home/home_viewmodel.dart';
import 'package:scheduler/screens/scheduler/scheduler_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        child: Consumer<HomeViewModel>(
          builder: ((context, model, child) => Scaffold(
                appBar: AppBar(),
                body: model.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        child: Container(
                          height: 500,
                          width: 500,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(model.schedulerMessage,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black ),),
                              SizedBox(
                                height: 50,
                              ),
                              model.schedulerList.isEmpty
                                  ? button(context, 'Add Schedule', model)
                                  : button(context, 'Edit schedule', model)
                            ],
                          ),
                        ),
                      ),
              )),
        ));
  }

  Widget button(context, text, HomeViewModel model) {
    return ElevatedButton(
        onPressed: () async {
          var result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => SchedulerView()));
          if (result ?? false) {
            model.getAllScheduler();
          }
        },
        child: Text('$text'));
  }
}
