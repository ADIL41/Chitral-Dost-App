import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitral_dost_app/provider/worker_provider.dart';
import 'package:chitral_dost_app/screens/worker_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WorkerListScreen extends StatefulWidget {
  final String serviceLabel;
  const WorkerListScreen({super.key, required this.serviceLabel});

  @override
  State<WorkerListScreen> createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        Provider.of<WorkerProvider>(
          context,
          listen: false,
        ).initLocationAndWorkers(widget.serviceLabel);
        _isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkerProvider>();

    final workers = provider.filteredWorkers;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.serviceLabel} Workers',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[800],
        centerTitle: true,
        actions: [
          if (provider.isLoading && workers.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            IconButton(
              icon: Icon(
                provider.userLocation != null
                    ? Icons.location_on
                    : Icons.location_off,
                color: Colors.white,
              ),

              onPressed: () => context.read<WorkerProvider>().refreshLocation(),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildRadiusSlider(provider),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search within ${widget.serviceLabel}...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),

              onChanged: (value) =>
                  context.read<WorkerProvider>().setSearchText(value),
            ),
          ),

          if (provider.errorMessage.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.orange[100],
              child: Text(
                provider.errorMessage,
                style: const TextStyle(color: Colors.deepOrange),
              ),
            ),

          Expanded(child: _buildListContent(provider)),
        ],
      ),
    );
  }

  Widget _buildRadiusSlider(WorkerProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search Radius: ${provider.radius.round()} km',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    label: Text(
                      provider.userLocation != null
                          ? 'Location On'
                          : 'Location Off',
                    ),
                    backgroundColor: provider.userLocation != null
                        // ignore: deprecated_member_use
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.15)
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ],
              ),
              Slider(
                value: provider.radius,
                min: 1,
                max: 50,
                divisions: 49,
                label: '${provider.radius.round()} km',

                onChanged: (val) =>
                    context.read<WorkerProvider>().setRadius(val),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListContent(WorkerProvider provider) {
    final workers = provider.filteredWorkers;

    if (provider.isLoading && workers.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    if (provider.userLocation == null && !provider.isLoading) {
      return Center(
        child: ElevatedButton(
          onPressed: () => context.read<WorkerProvider>().refreshLocation(),
          child: const Text('Enable Location'),
        ),
      );
    }

    if (workers.isEmpty) {
      return const Center(
        child: Text(
          textAlign: TextAlign.center,
          'No workers found. Try increasing radius or changing search text.',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: workers.length,
      itemBuilder: (context, index) {
        final worker = workers[index];

        final String? profilePictureUrl = worker.profilePictureUrl;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 28,
                  backgroundImage:
                      (profilePictureUrl != null &&
                          profilePictureUrl.isNotEmpty)
                      ? CachedNetworkImageProvider(profilePictureUrl)
                            as ImageProvider<Object>?
                      : null,

                  child:
                      (profilePictureUrl == null || profilePictureUrl.isEmpty)
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),

                if (worker.distanceInKm != null)
                  Positioned(
                    bottom: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${worker.distanceInKm!.toStringAsFixed(1)} km',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              worker.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(worker.place),
                Text(
                  worker.description,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkerProfile(worker: worker),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
