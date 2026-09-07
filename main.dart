import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Glass Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        primaryColor: const Color(0xFF1DB954),
        fontFamily: 'sans-serif',
      ),
      home: const CastMusicScreen(),
    );
  }
}

class CastMusicScreen extends StatefulWidget {
  const CastMusicScreen({Key? key}) : super(key: key);

  @override
  State<CastMusicScreen> createState() => _CastMusicScreenState();
}

class _CastMusicScreenState extends State<CastMusicScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  bool isLiked = false;
  bool isCastingToTV = false;
  Color accentColor = const Color(0xFF1DB954);

  // Valeurs de l'égaliseur audio
  double bassGain = 3.0;
  double midGain = 0.0;
  double trebleGain = 2.5;
  double preAmp = 1.0;

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

  void _togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _toggleCast() {
    setState(() {
      isCastingToTV = !isCastingToTV;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCastingToTV ? "Connecté à la Google TV (Cast actif)" : "Mode Téléphone réactivé"),
        backgroundColor: accentColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Ouvre le panneau de l'égaliseur professionnel
  void _openEqualizerPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131826).withOpacity(0.85),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.equalizer, color: Colors.greenAccent),
                              SizedBox(width: 10),
                              Text(
                                "Égaliseur Pro Audio",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white70),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      
                      // Préréglages rapides
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPresetButton("Shatta / Bass", () {
                            setModalState(() {
                              bassGain = 8.0;
                              midGain = -1.0;
                              trebleGain = 5.0;
                            });
                            setState(() {});
                          }),
                          _buildPresetButton("Dancehall", () {
                            setModalState(() {
                              bassGain = 6.0;
                              midGain = 2.0;
                              trebleGain = 4.0;
                            });
                            setState(() {});
                          }),
                          _buildPresetButton("Flat (Neutre)", () {
                            setModalState(() {
                              bassGain = 0.0;
                              midGain = 0.0;
                              trebleGain = 0.0;
                            });
                            setState(() {});
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Contrôles des bandes de fréquences
                      _buildSliderRow("Basses (60Hz)", bassGain, -10.0, 12.0, (val) {
                        setModalState(() => bassGain = val);
                        setState(() {});
                      }),
                      _buildSliderRow("Médiums (1kHz)", midGain, -10.0, 12.0, (val) {
                        setModalState(() => midGain = val);
                        setState(() {});
                      }),
                      _buildSliderRow("Aigus (14kHz)", trebleGain, -10.0, 12.0, (val) {
                        setModalState(() => trebleGain = val);
                        setState(() {});
                      }),
                      _buildSliderRow("Pré-ampli", preAmp, 0.0, 6.0, (val) {
                        setModalState(() => preAmp = val);
                        setState(() {});
                      }),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPresetButton(String title, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.1),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      onPressed: onTap,
      child: Text(title, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildSliderRow(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            Text("${value.toStringAsFixed(1)} dB", style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: accentColor,
          inactiveColor: Colors.white24,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan Liquid Glass avec dégradés lumineux
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.2),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(color: Colors.transparent),
          ),

          // Contenu principal
          SafeArea(
            child: Column(
              children: [
                // Barre de navigation supérieure avec Égaliseur et Chromecast TV
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Liquid Glass Music",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Row(
                        children: [
                          // Bouton Égaliseur direct
                          IconButton(
                            icon: const Icon(Icons.equalizer, color: Colors.greenAccent),
                            onPressed: _openEqualizerPanel,
                            tooltip: "Ouvrir l'égaliseur",
                          ),
                          // Bouton de Cast Google TV interactif
                          IconButton(
                            icon: Icon(
                              isCastingToTV ? Icons.cast_connected : Icons.cast,
                              color: isCastingToTV ? Colors.greenAccent : Colors.white70,
                            ),
                            onPressed: _toggleCast,
                            tooltip: "Diffuser sur Google TV",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (isCastingToTV)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.5)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.tv, color: Colors.greenAccent, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Diffusion en cours sur Google TV",
                          style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Pochette d'album style Verre Liquide (Glassmorphism)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.album,
                              size: 100,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Shatta & Dancehall Vibe",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "DJIMII PROD",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Contrôles de lecture et barre de progression
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.redAccent : Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                          ),
                          const Text("1:24", style: TextStyle(color: Colors.white54)),
                          const Text("3:45", style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: accentColor,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        ),
                        value: 0.35,
                        onChanged: (val) {},
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shuffle, color: Colors.white60),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_previous, size: 36, color: Colors.white),
                            onPressed: () {},
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accentColor,
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 36,
                                color: Colors.white,
                              ),
                              onPressed: _togglePlay,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next, size: 36, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.repeat, color: Colors.white60),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
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
