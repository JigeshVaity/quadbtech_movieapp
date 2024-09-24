import 'package:flutter/material.dart';
import 'package:quadbtechapp/screen/model/Detailpage.dart';
import 'package:quadbtechapp/screen/model/Post.dart' as postModel;
import 'package:quadbtechapp/screen/model/RemoteServices.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<postModel.Post>? allPosts;
  List<postModel.Post>? filteredPosts;
  bool isLoading = false;

  // Fetch all movies from the remote service
  void fetchAllMovies() async {
    setState(() {
      isLoading = true;
    });

    allPosts = await RemoteServices().getPosts();
    filteredPosts = allPosts; // Initially show all posts
    setState(() {
      isLoading = false;
    });
  }

  // Filter movies based on the search query
  void filterMovies(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredPosts = allPosts;
      });
    } else {
      setState(() {
        filteredPosts = allPosts
            ?.where((post) =>
            post.show.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllMovies(); // Fetch movies when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the background to black
      appBar: AppBar(
        title: const Text(
          "Search Movies",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black, // Black AppBar
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, // Responsive width for search bar
              child: TextField(
                onChanged: (value) {
                  filterMovies(value); // Filter movies based on the query
                },
                style: const TextStyle(color: Colors.white), // Text color white
                decoration: InputDecoration(
                  hintText: "Search for movies...",
                  hintStyle: const TextStyle(color: Colors.grey), // Grey hint text
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800], // Dark background for search bar
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white), // White border
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder( // Red border when focused
                    borderSide: const BorderSide(color: Colors.red, width: 2.0), // Red color border
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          // Display search results
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredPosts != null && filteredPosts!.isNotEmpty
              ? Expanded(
            child: ListView.builder(
              itemCount: filteredPosts!.length,
              itemBuilder: (context, index) {
                final post = filteredPosts![index];
                return Card(
                  color: Colors.grey[900], // Dark card background
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Margin for card
                  child: ListTile(
                    leading: post.show.image?.medium != null
                        ? Image.network(post.show.image!.medium)
                        : const Placeholder(
                      fallbackHeight: 100,
                      fallbackWidth: 70,
                    ),
                    title: Text(
                      post.show.name,
                      style: const TextStyle(color: Colors.white), // White text
                    ),
                    subtitle: Text(
                      post.show.genres.join(", "),
                      style: TextStyle(color: Colors.grey[300]), // Light grey text
                    ),
                    onTap: () {
                      // Navigate to detail page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailPage(movie: post),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
              : const Expanded(
            child: Center(
              child: Text(
                "No movies found",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
