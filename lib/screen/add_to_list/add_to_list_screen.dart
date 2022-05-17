import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/model/item_model.dart';
import 'package:mini_project/screen/account/account_view_model.dart';
import 'package:mini_project/screen/home/home_view_model.dart';
import 'package:provider/provider.dart';

class AddToListScreen extends StatefulWidget {
  const AddToListScreen({ Key? key, required this.item} ) : super(key: key);
  final Item item;

  @override
  State<AddToListScreen> createState() => _AddToListScreenState();
}

class _AddToListScreenState extends State<AddToListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reviewCtrl = TextEditingController();
  double? _rating;
  String? status;

  @override
  void initState() {
    super.initState();
    status = widget.item.status;
    if(widget.item.myReview != null){
      _reviewCtrl.text = widget.item.myReview!;
    }
    if(widget.item.myRating != null){
      _rating = double.parse(widget.item.myRating!) ;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _reviewCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final accountViewModel = Provider.of<AccountViewModel>(context);
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add to list Settings'),
        centerTitle: true,
      ),
      body : Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                setYourStatus(),
                yourRatingReviewSet(),
                buttonsToSave(accountViewModel: accountViewModel, homeViewModel: homeViewModel)
              ],
            ),
          )
        ),
      )
    );
  }

  Widget setYourStatus(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Set your Status', style: GoogleFonts.signikaNegative(fontSize: 20)),
          const SizedBox(width: 10,),
          DropdownButton(
            value: status,
            items: <String>['Plan to watch','Watching','Finished','Dropped']
            .map((value) => DropdownMenuItem<String>(child: Text(value, style: GoogleFonts.signikaNegative(fontSize: 18),), value: value,)).toList(),
            onChanged: (String? newValue){
              setState(() {
                status = newValue;
              });
            }
          )
        ]
      ),
    );
  }

  Widget yourRatingReviewSet(){
    if(status == 'Watching'){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Your Rating (${_rating ?? "0-10"})', style: GoogleFonts.signikaNegative(fontSize: 20),),
          ),
          Slider(
            value: _rating == null ? 0 : _rating!,
            max: 10,
            divisions: 20,
            label: _rating == null ? '0' : _rating!.toString(),
            activeColor: Colors.deepPurple,
            onChanged: (newValue){
              setState(() {
                _rating = newValue;
              });
            }
          ),
        ],
      );
    }
    if(status == 'Finished' || status == 'Dropped'){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('Your Rating (${_rating ?? "0-10"})', style: GoogleFonts.signikaNegative(fontSize: 20),),
          ),
          Slider(
            value: _rating == null ? 0 : _rating!,
            max: 10,
            divisions: 20,
            label: _rating == null ? '0' : _rating!.toString(),
            activeColor: Colors.deepPurple,
            onChanged: (newValue){
              setState(() {
                _rating = newValue;
              });
            }
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Your Review', style: GoogleFonts.signikaNegative(fontSize: 20)),
          ),
          TextFormField(
            controller: _reviewCtrl,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.deepPurple)
              ),
              label: Center(child: Text('What you think about the series/movies you have watched', textAlign: TextAlign.center, style: GoogleFonts.signikaNegative(),)),
            ),
            maxLines: 4,
            validator: (newValue){
              if(newValue == ' '){
                return 'Please add a proper data';
              }
              if(newValue!.contains('  ')){
                return 'Your review contains 2 spaces, please delete it';
              }
              return null;
            },
          )
        ],
      );
    }else{
      return const SizedBox(width: 0, height: 0,);
    }
  }

  Widget buttonsToSave({required AccountViewModel accountViewModel, required HomeViewModel homeViewModel}){
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ElevatedButton(
            onPressed: status == null || (widget.item.status == status && widget.item.status == 'Plan to watch') ? null : 
            () {
              final item = widget.item;
              late SnackBar snackBar;
              
              if(item.status != null){
                item.status = status;
                item.myReview = _reviewCtrl.text.isEmpty ? null : _reviewCtrl.text;
                item.myRating = _rating?.toString();
                accountViewModel.updateList(item);
                snackBar = SnackBar(content: Text('${item.title} successfully updated in your list', style: GoogleFonts.signikaNegative()));
              }
              else{
                item.status = status;
                item.myReview = _reviewCtrl.text.isEmpty ? null : _reviewCtrl.text;
                item.myRating = _rating?.toString();
                accountViewModel.addToList(item);
                snackBar = SnackBar(content: Text('${item.title} successfully added to your list', style: GoogleFonts.signikaNegative()));
              }
      
              ScaffoldMessenger.of(context).showSnackBar(snackBar);            
              Navigator.of(context).pop();
            },
            child: const Text('Save')
          ),
        ),
      );  
  }
}