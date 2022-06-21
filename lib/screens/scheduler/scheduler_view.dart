import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/models/scheduler.dart';
import 'package:scheduler/screens/scheduler/scheduler_viewmodel.dart';

class SchedulerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SchedulerViewModel(),
      child: Consumer<SchedulerViewModel>(
          builder: ((context, model, child) => Scaffold(
                appBar: AppBar(
                  title: Text('Edit Scheduler'),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: model.schedulerMarker.length,
                          itemBuilder: ((context, index) {
                            if (model.schedulerMarker[index]['avalilable']) {
                              return availableTile(
                                  model.schedulerMarker[index]['day'],
                                  model,
                                  model.getSchedulerByID(
                                      model.schedulerMarker[index]['day']));
                            } else {
                              return notAvailableTile(
                                  model.schedulerMarker[index]['day'], model);
                            }
                          })),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          model.save(context);
                        },
                        child: Text('Save'))
                  ],
                ),
              ))),
    );
  }

  Widget notAvailableTile(day, SchedulerViewModel model) {
    print(day);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    model.setAvailable(day);
                  },
                  icon: const Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Colors.grey,
                  )),
              const SizedBox(
                width: 20,
              ),
              Text(
                day,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                'Unavailable',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
        const Divider()
      ],
    );
  }

  Widget availableTile(day, SchedulerViewModel model, Scheduler scheduler) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    model.setNotAvailable(day);
                  },
                  icon: const Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Colors.green,
                  )),
              const SizedBox(
                width: 20,
              ),
              Text(
                day,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 20,
              ),
              scheduler.isMorningAvailable
                  ? selectedChip(day, 'Morning', model)
                  : notSelectedChip(day, 'Morning', model),
              scheduler.isAfterNoonAvailable
                  ? selectedChip(day, 'Afternoon', model)
                  : notSelectedChip(day, 'Afternoon', model),
              scheduler.isEveningAvailable
                  ? selectedChip(day, 'Evening', model)
                  : notSelectedChip(day, 'Evening', model)
            ],
          ),
        ),
        const Divider()
      ],
    );
  }

  Widget selectedChip(day, text, SchedulerViewModel model) {
    return InkWell(
      onTap: () {
        model.updateSchedule(day, text, false);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: Colors.purple)),
        child: Text(
          text,
          style: TextStyle(color: Colors.purple),
        ),
      ),
    );
  }

  Widget notSelectedChip(day, text, SchedulerViewModel model) {
    return InkWell(
      onTap: () {
        model.updateSchedule(day, text, true);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: Colors.grey)),
        child: Text(
          text,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
