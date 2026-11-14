import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

const bg = Color(0xFF0D0F0E), card = Color(0xFF181C1A), line = Color(0xFF2A312D);
const lime = Color(0xFFB6F400), orange = Color(0xFFFF5A1F), mute = Color(0xFF8E9A92);

final streak = ValueNotifier<int>(7);
final xp = ValueNotifier<int>(40);

void main() => runApp(const BlayzApp());

class BlayzApp extends StatelessWidget {
  const BlayzApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blayz Sport',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: bg,
          colorScheme: const ColorScheme.dark(primary: lime),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: const Color(0xFF121513),
            indicatorColor: lime.withOpacity(.18),
            labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 11)),
          ),
        ),
        home: const Splash(),
      );
}

Route<T> fade<T>(Widget w) => PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => w,
    transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c));

class Btn extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool outline;
  const Btn(this.text, this.onTap, {super.key, this.outline = false});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 54,
        child: outline
            ? OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: lime, width: 1.5),
                    foregroundColor: lime,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)))
            : FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                    backgroundColor: lime,
                    foregroundColor: bg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800))),
      );
}

class Tile extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool selected;
  const Tile({super.key, required this.child, this.onTap, this.selected = false});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: selected ? lime : line, width: selected ? 1.6 : 1)),
          child: child,
        ),
      );
}

Widget iconBox(IconData i, {Color c = lime}) => Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
    child: Icon(i, color: c, size: 28));

Widget title(String t) => Text(t, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, height: 1.1));
Widget sub(String t) => Text(t, style: const TextStyle(color: mute, fontSize: 14, height: 1.35));

// ---------- Splash ----------
class Splash extends StatefulWidget {
  const Splash({super.key});
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) Navigator.pushReplacement(context, fade(const Intro()));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutBack,
            builder: (_, v, child) => Opacity(opacity: v.clamp(0, 1), child: Transform.scale(scale: .7 + .3 * v, child: child)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ClipRRect(borderRadius: BorderRadius.circular(40), child: Image.asset('assets/logo.png', width: 170)),
              const SizedBox(height: 22),
              const Text('BLAYZ SPORT', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 1)),
              const SizedBox(height: 6),
              const Text('Hayatta Kal ve Güçlen', style: TextStyle(color: mute, fontSize: 16)),
            ]),
          ),
        ),
      );
}

// ---------- Intro ----------
class Intro extends StatefulWidget {
  const Intro({super.key});
  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final pc = PageController();
  int p = 0;
  static const pages = [
    (Icons.sports_soccer, 'Senin için, sadece spor değil', 'Futboldan sokak savunmasına, her yaşa uygun antrenmanlar.'),
    (Icons.restaurant, 'Cebine uygun beslenme', 'Bütçeni gir, ucuz ve yüksek proteinli tarifleri gör.'),
    (Icons.link_off, 'Zinciri kır, güçlen', 'Kötü alışkanlıkları bırak, topluluktan destek al.'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(children: [
              Expanded(
                child: PageView(
                  controller: pc,
                  onPageChanged: (i) => setState(() => p = i),
                  children: [
                    for (final pg in pages)
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: card, border: Border.all(color: lime, width: 2)),
                            child: Icon(pg.$1, size: 80, color: lime)),
                        const SizedBox(height: 36),
                        Text(pg.$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        sub(pg.$3),
                      ]),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (int i = 0; i < pages.length; i++)
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.all(4),
                      width: i == p ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(color: i == p ? lime : line, borderRadius: BorderRadius.circular(4))),
              ]),
              const SizedBox(height: 20),
              Btn(p == pages.length - 1 ? 'Hesap oluştur' : 'Devam', () {
                if (p == pages.length - 1) {
                  Navigator.push(context, fade(const SignUp()));
                } else {
                  pc.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                }
              }),
              const SizedBox(height: 10),
              Btn('Giriş yap', () => Navigator.push(context, fade(const SignUp())), outline: true),
            ]),
          ),
        ),
      );
}

// ---------- Sign up ----------
class SignUp extends StatelessWidget {
  const SignUp({super.key});
  Widget field(String h, IconData i, {bool obscure = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          obscureText: obscure,
          decoration: InputDecoration(
              hintText: h,
              prefixIcon: Icon(i, color: mute),
              filled: true,
              fillColor: card,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)),
        ),
      );
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: bg, elevation: 0),
        body: ListView(padding: const EdgeInsets.all(22), children: [
          title('Yeni hesap oluştur'),
          const SizedBox(height: 20),
          field('Ad Soyad', Icons.person_outline),
          field('Doğum tarihi (GG/AA/YYYY)', Icons.cake_outlined),
          field('E-posta', Icons.mail_outline),
          field('Şifre', Icons.lock_outline, obscure: true),
          field('Şifre tekrar', Icons.lock_outline, obscure: true),
          sub('Kaydolarak Kullanım Koşulları ve Gizlilik Politikası\'nı kabul etmiş olursun.'),
          const SizedBox(height: 18),
          Btn('Kaydol ve keşfet', () => Navigator.push(context, fade(const PathPick()))),
        ]),
      );
}

// ---------- Path pick ----------
class PathPick extends StatefulWidget {
  const PathPick({super.key});
  @override
  State<PathPick> createState() => _PathPickState();
}

class _PathPickState extends State<PathPick> {
  int sel = 0;
  static const items = [
    (Icons.sports_soccer, 'Futbol geleceği', 'Top kontrolü, şut, pas'),
    (Icons.fitness_center, 'Güç ve fizik', 'Kas, yağ yakma, mobilite'),
    (Icons.sports_mma, 'Sokak savunması', 'Boks, deşarj, öz güven'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(backgroundColor: bg, elevation: 0),
        body: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            title('Antrenman yolunu seç'),
            const SizedBox(height: 6),
            sub('İstediğin zaman değiştirebilirsin.'),
            const SizedBox(height: 22),
            for (int i = 0; i < items.length; i++)
              Tile(
                selected: sel == i,
                onTap: () => setState(() => sel = i),
                child: Row(children: [
                  iconBox(items[i].$1),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(items[i].$2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    sub(items[i].$3),
                  ])),
                  if (sel == i) const Icon(Icons.check_circle, color: lime),
                ]),
              ),
            const Spacer(),
            Btn('Devam et', () => Navigator.pushAndRemoveUntil(context, fade(const Shell()), (r) => false)),
          ]),
        ),
      );
}

// ---------- Shell ----------
class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: IndexedStack(index: i, children: [
            Home(onTab: (t) => setState(() => i = t)),
            const Train(),
            const Food(),
            const Chain(),
            const Community(),
            const Profile(),
          ]),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          onDestinationSelected: (v) => setState(() => i = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore, color: lime), label: 'Keşfet'),
            NavigationDestination(icon: Icon(Icons.fitness_center), selectedIcon: Icon(Icons.fitness_center, color: lime), label: 'Antrenman'),
            NavigationDestination(icon: Icon(Icons.restaurant_outlined), selectedIcon: Icon(Icons.restaurant, color: lime), label: 'Beslenme'),
            NavigationDestination(icon: Icon(Icons.link_off), selectedIcon: Icon(Icons.link_off, color: lime), label: 'Zincir'),
            NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups, color: lime), label: 'Topluluk'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: lime), label: 'Profil'),
          ],
        ),
      );
}

// ---------- Home ----------
class Home extends StatefulWidget {
  final void Function(int) onTab;
  const Home({super.key, required this.onTab});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int mood = -1;
  bool done = false;
  static const moods = [
    (Icons.sentiment_very_satisfied, 'Enerjik: 30 dk güç antrenmanı önerildi.'),
    (Icons.sentiment_satisfied, 'İyi: Futbol tekniği günü.'),
    (Icons.sentiment_neutral, 'Yorgun: 10 dk sakinleştirici mobilite önerildi.'),
    (Icons.sentiment_dissatisfied, 'Gergin: 15 dk boks torbası ile deşarj önerildi.'),
  ];
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Hoş geldin,', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const Text('Martin!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: lime)),
          ])),
          ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.asset('assets/logo.png', width: 48)),
        ]),
        const SizedBox(height: 20),
        const Text('Bugün nasıl hissediyorsun?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          for (int i = 0; i < moods.length; i++)
            GestureDetector(
              onTap: () => setState(() => mood = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 66,
                height: 56,
                decoration: BoxDecoration(color: mood == i ? lime : card, borderRadius: BorderRadius.circular(16)),
                child: Icon(moods[i].$1, size: 32, color: mood == i ? bg : mute),
              ),
            ),
        ]),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: mood < 0
              ? const SizedBox(width: double.infinity)
              : Padding(padding: const EdgeInsets.only(top: 12), child: Tile(child: Row(children: [
                  const Icon(Icons.bolt, color: orange),
                  const SizedBox(width: 10),
                  Expanded(child: Text(moods[mood].$2)),
                ]))),
        ),
        const SizedBox(height: 14),
        ValueListenableBuilder<int>(
          valueListenable: xp,
          builder: (_, v, __) => Tile(
            selected: done,
            onTap: () {
              if (!done) {
                setState(() => done = true);
                xp.value += 20;
              }
            },
            child: Row(children: [
              iconBox(done ? Icons.check_circle : Icons.radio_button_unchecked),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Günlük görevim', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                sub(done ? 'Tamamlandı. +20 puan' : '30 dk temel futbol. Tamamlamak için dokun.'),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: (v % 100) / 100),
                  duration: const Duration(milliseconds: 500),
                  builder: (_, t, __) => LinearProgressIndicator(value: t, minHeight: 8, color: lime, backgroundColor: bg, borderRadius: BorderRadius.circular(8)),
                ),
              ])),
            ]),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Senin için', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Tile(onTap: () => widget.onTab(1), child: Row(children: [iconBox(Icons.sports_soccer), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Top kontrolü ve pas', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), sub('12 dk · Başlangıç')])), const Icon(Icons.chevron_right, color: mute)])),
        Tile(onTap: () => widget.onTab(2), child: Row(children: [iconBox(Icons.rice_bowl, c: orange), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Bütçe dostu protein', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), sub('Mercimek, nohut, yumurta')])), const Icon(Icons.chevron_right, color: mute)])),
      ]);
}

// ---------- Train ----------
class Train extends StatefulWidget {
  const Train({super.key});
  @override
  State<Train> createState() => _TrainState();
}

class _TrainState extends State<Train> {
  final ex = [('Ayak içi pas', '3 × 20 tekrar'), ('Top sürme', '3 × 30 sn'), ('Duvara pas', '3 × 15 tekrar'), ('Soğuma', '2 dk')];
  final checked = <int>{};
  Timer? t;
  int sec = 0;
  bool get running => t != null;
  void toggle() {
    if (running) {
      t!.cancel();
      setState(() => t = null);
    } else {
      setState(() => t = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => sec++)));
    }
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mm = (sec ~/ 60).toString().padLeft(2, '0'), ss = (sec % 60).toString().padLeft(2, '0');
    return ListView(padding: const EdgeInsets.all(20), children: [
      title('Top kontrolü ve pas'),
      const SizedBox(height: 6),
      sub('12 dk · Başlangıç · Ekipman: top'),
      const SizedBox(height: 16),
      Container(
        height: 140,
        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18), border: Border.all(color: line)),
        child: Center(child: Text('$mm:$ss', style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: lime))),
      ),
      const SizedBox(height: 16),
      for (int i = 0; i < ex.length; i++)
        Tile(
          selected: checked.contains(i),
          onTap: () => setState(() => checked.contains(i) ? checked.remove(i) : checked.add(i)),
          child: Row(children: [
            iconBox(checked.contains(i) ? Icons.check : Icons.sports_soccer, c: checked.contains(i) ? lime : mute),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(ex[i].$1, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), sub(ex[i].$2)])),
          ]),
        ),
      const SizedBox(height: 6),
      Btn(running ? 'Duraklat' : 'Antrenmanı başlat', toggle),
      if (checked.length == ex.length) ...[
        const SizedBox(height: 10),
        Btn('Bitir (+50 puan)', () {
          xp.value += 50;
          t?.cancel();
          setState(() {
            t = null;
            sec = 0;
            checked.clear();
          });
        }, outline: true),
      ],
    ]);
  }
}

// ---------- Food ----------
class Food extends StatefulWidget {
  const Food({super.key});
  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  double budget = 60;
  static const recipes = [
    ('Mercimek çorbası + bulgur', 35, 28),
    ('Yer fıstığı ezmeli yulaf', 30, 22),
    ('Nohutlu yumurta', 45, 32),
    ('Tavuklu nohut tabağı', 80, 45),
    ('Kuru fasulye + yoğurt', 55, 30),
  ];
  @override
  Widget build(BuildContext context) {
    final list = recipes.where((r) => r.$2 <= budget).toList();
    return ListView(padding: const EdgeInsets.all(20), children: [
      title('Bütçe dostu beslenme'),
      const SizedBox(height: 6),
      sub('Günlük bütçeni ayarla, uygun tarifleri gör.'),
      const SizedBox(height: 16),
      Tile(child: Column(children: [
        Text('${budget.round()} ₺', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: lime)),
        Slider(value: budget, min: 20, max: 120, divisions: 20, activeColor: lime, onChanged: (v) => setState(() => budget = v)),
      ])),
      if (list.isEmpty) Tile(child: const Text('Bu bütçeye uygun tarif yok. Bütçeyi biraz artır.')),
      for (final r in list)
        Tile(child: Row(children: [
          iconBox(Icons.rice_bowl, c: orange),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(r.$1, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), sub('${r.$2} ₺ · ${r.$3} g protein')])),
        ])),
    ]);
  }
}

// ---------- Chain ----------
class Ring extends CustomPainter {
  final double p;
  Ring(this.p);
  @override
  void paint(Canvas c, Size s) {
    final r = Rect.fromLTWH(8, 8, s.width - 16, s.height - 16);
    final base = Paint()..style = PaintingStyle.stroke..strokeWidth = 14..color = line;
    final fg = Paint()..style = PaintingStyle.stroke..strokeWidth = 14..strokeCap = StrokeCap.round..color = lime;
    c.drawArc(r, 0, math.pi * 2, false, base);
    c.drawArc(r, -math.pi / 2, math.pi * 2 * p, false, fg);
  }

  @override
  bool shouldRepaint(Ring o) => o.p != p;
}

class Chain extends StatefulWidget {
  const Chain({super.key});
  @override
  State<Chain> createState() => _ChainState();
}

class _ChainState extends State<Chain> {
  String msg = 'Her gün küçük bir zafer. Devam et.';
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
        valueListenable: streak,
        builder: (_, d, __) => ListView(padding: const EdgeInsets.all(20), children: [
          Center(child: title('Zinciri kır')),
          const SizedBox(height: 24),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (d / 30).clamp(0, 1).toDouble()),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              builder: (_, p, __) => SizedBox(
                width: 230,
                height: 230,
                child: CustomPaint(
                  painter: Ring(p),
                  child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('$d', style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w900)),
                    const Text('temiz gün', style: TextStyle(color: mute, fontSize: 16)),
                  ])),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Btn('Bugün temiz geçti', () {
            streak.value++;
            xp.value += 10;
            setState(() => msg = 'Harika! Zincir kırılmadı. +10 puan');
          }),
          const SizedBox(height: 10),
          Btn('Zorlandım, destek al', () => setState(() => msg = 'Zorlanmak normal. 10 dk yürüyüşe çık ya da topluluğa yaz.'), outline: true),
          const SizedBox(height: 16),
          Tile(child: Row(children: [const Icon(Icons.favorite, color: orange), const SizedBox(width: 10), Expanded(child: Text(msg))])),
        ]),
      );
}

// ---------- Community ----------
class Community extends StatefulWidget {
  const Community({super.key});
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final posts = <(String, String)>[
    ('Bu hafta protein tozu alamadım, nohutla idare ettim. Sizce yeterli mi?', '2 sa önce · 14 destek'),
    ('30. gün! Sigarasız ilk koşumu yaptım.', '5 sa önce · 52 destek'),
  ];
  final c = TextEditingController();
  void add() {
    if (c.text.trim().isEmpty) return;
    setState(() => posts.insert(0, (c.text.trim(), 'şimdi · 0 destek')));
    c.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: bg,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: lime,
          foregroundColor: bg,
          icon: const Icon(Icons.edit),
          label: const Text('Paylaş'),
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: card,
            builder: (_) => Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: c, autofocus: true, maxLines: 3, decoration: const InputDecoration(hintText: 'Anonim olarak paylaş...')),
                const SizedBox(height: 12),
                Btn('Paylaş', add),
              ]),
            ),
          ),
        ),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          title('Dayanışma duvarı'),
          const SizedBox(height: 6),
          sub('Anonim paylaş, birbirinizi destekleyin.'),
          const SizedBox(height: 16),
          for (final p in posts)
            Tile(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.$1, style: const TextStyle(fontSize: 15, height: 1.35)),
              const SizedBox(height: 8),
              Row(children: [const Icon(Icons.favorite_border, size: 16, color: orange), const SizedBox(width: 6), Text('Anonim · ${p.$2}', style: const TextStyle(color: mute, fontSize: 12))]),
            ])),
        ]),
      );
}

// ---------- Profile ----------
class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
        const SizedBox(height: 10),
        Center(child: ClipRRect(borderRadius: BorderRadius.circular(28), child: Image.asset('assets/logo.png', width: 100))),
        const SizedBox(height: 12),
        Center(child: title('Martin')),
        ValueListenableBuilder<int>(
          valueListenable: xp,
          builder: (_, v, __) => Center(child: sub('Seviye ${v ~/ 100 + 1} · $v puan · Futbol geleceği')),
        ),
        const SizedBox(height: 22),
        const Text('Rozetler', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final b in ['7 gün seri', 'İlk antrenman', 'Güçlü başlangıç'])
            Chip(label: Text(b), backgroundColor: card, side: const BorderSide(color: orange), avatar: const Icon(Icons.local_fire_department, color: orange, size: 18)),
        ]),
        const SizedBox(height: 22),
        const Text('Kuponlar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Tile(child: Row(children: [iconBox(Icons.local_activity, c: orange), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('%10 spor salonu indirimi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)), sub('Seviye 5\'te açılır')]))])),
      ]);
}
