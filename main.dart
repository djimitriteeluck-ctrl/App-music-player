import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:ui';

// Note: Vous ajouterez le package cast pour gérer la connexion à la Google TV
// import 'package:cast/cast.h'; 

class CastMusicScreen extends StatefulWidget {
  const CastMusicScreen({Key? key}) : super(key: key);

  @override
  State<CastMusicScreen> createState() => _CastMusicScreenState();
}

class _CastMusicScreenState extends State<CastMusicScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isLiked = false;
  bool isCastingToTV = false; // Indique si le son est envoyé sur la Google TV
  Color accentColor = const Color(0xFF1DB954); 

  @byteOrderMark
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        _audioPlayer.play();
      } else {
        _audioPlayer.pause();
      }
    });
  }

  // Fonction pour simuler ou lancer la connexion au Chromecast (Google TV)
  void _toggleCastToGoogleTV() {
    setState(() {
      isCastingToTV = !isCastingToTV;
    });
    // Ici, le SDK Chromecast envoie soit le fichier local (via un serveur HTTP local embarqué), 
    // soit l'URL du flux en streaming directement à la Google TV.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCastingToTV ? "Diffusion connectée à la Google TV 📺" : "Lecture basculée sur le téléphone 📱"),
        backgroundColor: accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan dynamique
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withOpacity(0.4),
                    const Color(0xFF0B0B0F),
                    const Color(0xFF0B0B0F),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Barre supérieure avec Recherche et Bouton Google Cast TV
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        color: Colors.white.withOpacity(0.1),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.white70),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                "Rechercher (Local & Streaming)...",
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                            ),
                            // Bouton Cast pour Google TV
                            IconButton(
                              icon: Icon(
                                isCastingzed: isCastingToTV ? Icons.cast_connected : Icons.cast,
                                color: isCastingToTV ? accentColor : Colors.white70,
                              ),
                              onPressed: _toggleCastToGoogleTV,
                              tooltip: "Caster sur Google TV",
                            ),
                            // Sélecteur de thèmes
                            PopupMenuButton<Color>(
                              icon: Icon(Icons.palette, color: accentColor),
                              onSelected: (Color color) {
                                setState(() {
                                  accentColor = color;
                                });
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: Color(0xFF1DB954), child: Text("Vert Spotify")),
                                const PopupMenuItem(value: Color(0xFFE91E63), child: Text("Rose / Rouge")),
                                const PopupMenuItem(value: Color(0xFF2196F3), child: Text("Bleu Néon")),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Grande Pochette d'album centrale
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Titre et Bouton Like
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Titre du Morceau",
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            isCastingToTV ? "Diffusion en cours sur Google TV 📺" : "Lecture sur l'appareil 📱",
                            style: TextStyle(color: accentColor, fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? accentColor : Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Barre de progression
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    value: 0.4,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                ),

                const SizedBox(height: 20),

                // Contrôles de lecture
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: const Icon(Icons.shuffle, color: Colors.white70), onPressed: () {}),
                    const SizedBox(width: 15),
                    IconButton(icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32), onPressed: () {}),
                    const SizedBox(width: 15),
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, color: accentColor),
                      child: IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black, size: 36),
                        onPressed: _togglePlayPause,
                      ),
                    ),
                    const SizedBox(width: 15),
                    IconButton(icon: const Icon(Icons.skip_next, color: Colors.white, size: 32), onPressed: () {}),
                    const SizedBox(width: 15),
                    IconButton(icon: const Icon(Icons.repeat, color: Colors.white70), onPressed: () {}),
                  ],
                ),

                const Spacer(),
              ],
            ),
          ),

          // Panneau Inférieur "Liquid Glass"
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavIcon(Icons.settings, "Paramètres"),
                      _buildNavIcon(Icons.equalizer, "Égaliseur"),
                      _buildNavIcon(Icons.album, "Albums"),
                      _buildNavIcon(Icons.wifi, "En Ligne"),
                      _buildNavIcon(Icons.folder_open, "Offline"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}
