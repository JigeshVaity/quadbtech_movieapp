import 'package:flutter/material.dart';
import 'package:quadbtechapp/screen/model/Post.dart' as postModel;

class MovieDetailPage extends StatelessWidget {
  final postModel.Post movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get device width and height
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTabletOrDesktop = constraints.maxWidth > 600; // Adjust based on your needs

        return Scaffold(
          appBar: AppBar(
            title: Text(movie.show.name),
            backgroundColor: Colors.black,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTabletOrDesktop ? 32.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Image
                  if (movie.show.image != null)
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                      child: Container(
                        height: screenHeight * (isTabletOrDesktop ? 0.5 : 0.4), // Adjust height for tablet/desktop
                        width: double.infinity,
                        child: Image.network(
                          movie.show.image!.original,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Movie Name
                  Text(
                    movie.show.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTabletOrDesktop ? 32 : screenWidth * 0.06, // Larger font for tablet/desktop
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Movie Status, Language, and Runtime in a Single Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildInfoRow(Icons.info_outline, movie.show.status.toString().split('.').last, screenWidth, isTabletOrDesktop),
                      buildInfoRow(Icons.language, movie.show.language.toString().split('.').last, screenWidth, isTabletOrDesktop),
                      buildInfoRow(Icons.access_time, movie.show.runtime != null ? '${movie.show.runtime} min' : 'N/A', screenWidth, isTabletOrDesktop),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Average Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellowAccent),
                      const SizedBox(width: 8),
                      Text(
                        "Average Rating: ${movie.show.rating.average != null ? movie.show.rating.average.toString() : 'N/A'}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTabletOrDesktop ? 18 : screenWidth * 0.045, // Adjust font size
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Play Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your play button action here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: isTabletOrDesktop ? screenWidth * 0.2 : screenWidth * 0.15, // Adjust padding for tablet/desktop
                        ),
                      ),
                      child: Text(
                        "Play",
                        style: TextStyle(
                          fontSize: isTabletOrDesktop ? 20 : screenWidth * 0.05, // Adjust font size
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Genres
                  buildInfoRow(Icons.category, "Genres: ${movie.show.genres.join(", ")}", screenWidth, isTabletOrDesktop),
                  const SizedBox(height: 12),

                  // Premiered Date
                  buildInfoRow(Icons.calendar_today, "Premiered: ${movie.show.premiered?.toLocal().toString().split(' ')[0] ?? 'N/A'}", screenWidth, isTabletOrDesktop),
                  const SizedBox(height: 12),

                  // Movie Summary
                  Text(
                    movie.show.summary,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTabletOrDesktop ? 18 : screenWidth * 0.045, // Adjust font size
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.black,
        );
      },
    );
  }

  // Helper function to build rows with icons and text
  Widget buildInfoRow(IconData icon, String text, double screenWidth, bool isTabletOrDesktop) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTabletOrDesktop ? 18 : screenWidth * 0.045, // Adjust font size
          ),
        ),
      ],
    );
  }
}
