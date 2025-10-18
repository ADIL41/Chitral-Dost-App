import 'package:chitral_dost_app/screens/booking_class.dart';
import 'package:flutter/material.dart';

class BookingDetail extends StatelessWidget {
  final List<Booking> bookings = [
    Booking(
      name: 'Ali Raza',
      title: 'Electrician',
      address: 'Chitral',
      phone: '03xxxxxxxxx',
      imageUrl: '',
    ),
    Booking(
      name: 'Fahad',
      title: 'Doctor',
      address: 'Drosh',
      phone: '03xxxxxxx',
      imageUrl: '',
    ),
    Booking(
      name: 'Ali Raza',
      title: 'Electrician',
      address: 'Chitral',
      phone: '03xxxxxxxxx',
      imageUrl: '',
    ),
    Booking(
      name: 'Fahad',
      title: 'Doctor',
      address: 'Drosh',
      phone: '03xxxxxxx',
      imageUrl: '',
    ),
    Booking(
      name: 'Ali Raza',
      title: 'Electrician',
      address: 'Chitral',
      phone: '03xxxxxxxxx',
      imageUrl: '',
    ),
    Booking(
      name: 'Fahad',
      title: 'Doctor',
      address: 'Drosh',
      phone: '03xxxxxxx',
      imageUrl: '',
    ),
  ];
  BookingDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        title: Text(
          'Booking Detail',
          style: TextStyle(color: Colors.orangeAccent),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          // ignore: non_constant_identifier_names
          final Booking = bookings[index];
          return Card(
            margin: EdgeInsets.all(12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Color(0xff84fab0), Color(0xff8fd3f4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(Booking.imageUrl),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Booking.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            Booking.title,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 6),
                          Text(Booking.address, style: TextStyle(fontSize: 14)),
                          SizedBox(height: 6),
                          Text(Booking.phone, style: TextStyle(fontSize: 14)),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Call Now'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
