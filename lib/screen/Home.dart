import 'package:flutter/material.dart';
import 'package:quadbtechapp/screen/model/Detailpage.dart';
import 'package:quadbtechapp/screen/model/Post.dart' as postModel;
import 'package:quadbtechapp/screen/model/RemoteServices.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<postModel.Post>?> _movies;
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _movies = RemoteServices().getPosts();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('QuadB Tech',
            style: TextStyle(
                fontSize: 26,
                color: Colors.red,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<postModel.Post>?>(  // Use FutureBuilder to get movie data
        future: _movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load data'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found'));
          } else {
            // Filter out movies without images
            List<postModel.Post> moviesWithImages = snapshot.data!
                .where((movie) => movie.show.image != null)
                .toList();

            return ListView(
              children: [
                buildMovieBanner(moviesWithImages), // Movie banner
                buildMovieSlider(moviesWithImages, 'Trending Now'), // Horizontal movie slider
                buildMovieSlider(moviesWithImages, 'Top Picks for You'), // Another horizontal movie slider
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildMovieBanner(List<postModel.Post> movies) {
    final movieSubset = movies.take(3).toList(); // Limit to 3 movies

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25, // Responsive height
          child: PageView.builder(
            controller: _pageController,
            itemCount: movieSubset.length,
            itemBuilder: (context, index) {
              final movie = movieSubset[index];
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    movie.show.image!.original,
                    fit: BoxFit.cover, // Use BoxFit.cover to maintain aspect ratio
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ),
              );
            },
          ),
        ),
        // Dot indicators for the PageView
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(movieSubset.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.white : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget buildMovieSlider(List<postModel.Post> movies, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            // Determine the number of movies to display based on screen width
            int itemCount = constraints.maxWidth > 600 ? 6 : 3; // 5 for wider screens, 3 for smaller

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.25, // Responsive height for slider
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length < itemCount ? movies.length : itemCount,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(movie: movie),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * (1 / itemCount), // Responsive width based on itemCount
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Curved radius
                        child: movie.show.image != null
                            ? Image.network(
                          movie.show.image!.original,
                          fit: BoxFit.cover, // Use BoxFit.cover to maintain aspect ratio
                          width: double.infinity,
                        )
                            : Container(
                          color: Colors.grey,
                          child: const Center(
                            child: Text(
                              'No Image Available',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
