'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"main.dart.js": "e18f3cd2f3a043cf50b4c6156fd7e19f",
"flutter_bootstrap.js": "735f3ae09605f6d760a795ba43d98089",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "dccd776b9d5624e17d6aee1dcac257c5",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "7e1c66951ac8258e84bc86d32f6e5f1e",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"assets/FontManifest.json": "f9097450010bd82cf16bb016ba2219d8",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "fcb76d7fe1d201b261528ec2bc6f6039",
"assets/NOTICES": "00a6fbf0230fb3fb97337108597be754",
"assets/AssetManifest.bin.json": "b535d449a67e4241c7b3bdeed68385a8",
"assets/assets/images/cheetah.png": "03a87c3189a07bddfb180f1fedc7aa85",
"assets/assets/images/ant.png": "1f8802be44cc138586e5c64b14e89cbd",
"assets/assets/images/cheese.png": "755dcbc784f07f7818e9015ae4b1cc32",
"assets/assets/images/axe.png": "db111b584e0c99dbe25ee8db09f9cff0",
"assets/assets/images/peregrine.png": "2e23a71224a92bc33b97918e125f8f07",
"assets/assets/images/arm.png": "d32c27ae522ab8fa9ca68d640902beec",
"assets/assets/images/tasks/apple.png": "645e1845325bc89e476ffa30786b34f5",
"assets/assets/images/tasks/square.png": "2fcb46e88a4e2efbfe2284c24608a790",
"assets/assets/images/tasks/circle.png": "027b710b994aaad87c8aff23602b66a4",
"assets/assets/images/tasks/triangle.png": "1728c96ebcadcbb4e4796c0b95d219da",
"assets/assets/images/tasks/ellipse.png": "7b0f91eed379dc7702a0592d8812e596",
"assets/assets/images/ants.png": "db5619c4f0494152647603428839cd63",
"assets/assets/images/cow.png": "28d0a01f643c31d04d5c9a92cf47161f",
"assets/assets/images/birch.png": "022a2f604ab47f6a767aca1c3f5fcc48",
"assets/assets/images/arc.png": "4a49373df0832bc633c3390fb7914a46",
"assets/assets/images/river.png": "7d398ad602da55c330eb35aebc8cb6e2",
"assets/assets/images/horns.png": "30354a2c2fc2fe64c6db063c121df524",
"assets/assets/images/apron.png": "37118f19fe57c8ab3699bece55246d1e",
"assets/assets/images/marlin.png": "6fc08ddb208258ca6001f5850e84182e",
"assets/assets/images/bark.jpg": "607a7a15246f6e48f353515e5639ba11",
"assets/assets/images/fish.png": "3630d1eaed228f8f451e43a3bf75a67a",
"assets/assets/images/anchor.png": "72fff44fbd6238512cd4ad9a312d81a1",
"assets/assets/images/mouth.png": "bda4e91492624ab0d7b2925e00882094",
"assets/assets/audio/sim.mp3": "35b64c58a75c0ba9d9346fd98a825e46",
"assets/assets/audio/ding.mp3": "aaa133b26647ab226ec6a2eb4a6fd976",
"assets/assets/audio/test.mp3": "aaa133b26647ab226ec6a2eb4a6fd976",
"assets/assets/audio/pronunciation/uk_rja.mp3": "386c1531a71542d34c9ad2c1c2e9b89a",
"assets/assets/audio/pronunciation/uk_arka.mp3": "e54dbcee8f1dc4784077f3f8b8a12b91",
"assets/assets/audio/pronunciation/uk_syr.mp3": "e3cdff9d02d9e25285ce804127366035",
"assets/assets/audio/pronunciation/uk_korabel.mp3": "28d0220a215ecc539c0e2a956418425a",
"assets/assets/audio/pronunciation/uk_rju.mp3": "5c63c04daa5394d04e79e523a2fbfe85",
"assets/assets/audio/pronunciation/uk_ry.mp3": "8fea95502a76a8c5ecfb5c130819afcf",
"assets/assets/audio/pronunciation/uk_rysj.mp3": "05c11c435fae1c928c6e83d03a87b23f",
"assets/assets/audio/pronunciation/uk_horikhy.mp3": "dd4248186da3f5d6f6c9dc9b904acb79",
"assets/assets/audio/pronunciation/uk_rjukzak.mp3": "e93f0eec3bea58171b499a8d9acf2a15",
"assets/assets/audio/pronunciation/uk_ba.mp3": "79ae72753b6486178ff1dd3694b7649f",
"assets/assets/audio/pronunciation/uk_ra.mp3": "6ea8623f5a2becbb973d076b0e5b14bd",
"assets/assets/audio/pronunciation/uk_sokyra.mp3": "112c6e7795e87cb80bad3ea5c18859e5",
"assets/assets/audio/pronunciation/uk_korova.mp3": "5a3275ca79fa7af122232e878c30e9d8",
"assets/assets/audio/pronunciation/uk_va.mp3": "4e831d213c5943d64e41ec298661dad0",
"assets/assets/audio/pronunciation/uk_baraban.mp3": "e5fc27026cc8ae05634c46702e5793e0",
"assets/assets/audio/pronunciation/uk_raketa.mp3": "7dd73894caeb4868cde60295ae0ebe98",
"assets/assets/audio/pronunciation/uk_rys.mp3": "53704340f9b5d07edb11f4bf69f23e34",
"assets/assets/audio/pronunciation/uk_fartukh.mp3": "07f6998e79a1f93d62678a915f74128e",
"assets/assets/audio/pronunciation/uk_arfa.mp3": "b6a97f3951c858ed3f23f61cc56c7dec",
"assets/assets/audio/pronunciation/uk_ruchka.mp3": "d0df3aff6dc09607c7222fdd9746eb72",
"assets/assets/audio/pronunciation/uk_ro.mp3": "500863d8725dad30c628406e6a2a84b4",
"assets/assets/audio/pronunciation/uk_richka.mp3": "2f15edfc7567e314e8b55acc99f0614f",
"assets/assets/audio/pronunciation/uk_hryb.mp3": "0fdae9639bd1cd0eacb9f0b9ba065f93",
"assets/assets/audio/pronunciation/uk_ru.mp3": "0b1156d69b0c8624be6a9fa11c182772",
"assets/assets/audio/pronunciation/uk_hrusha.mp3": "33766829de2cb39bfd3860d961bea0f8",
"assets/assets/audio/pronunciation/uk_pero.mp3": "aeab1272201c14cdbfedc43bcc5db97c",
"assets/assets/audio/pronunciation/uk_ar.mp3": "eaf33d8dfcdeb0a0e5da06acc343ebda",
"assets/assets/audio/pronunciation/uk_rozhevyj.mp3": "511ee230ae3a66b923edd0da520c222e",
"assets/assets/audio/pronunciation/uk_ryba.mp3": "d181badd61a24cf11f2d4d1db606b831",
"assets/assets/audio/pronunciation/uk_romashka.mp3": "b14b1cc68a3d8ceaf96fb3673545c8ca",
"assets/assets/audio/pronunciation/uk_ko.mp3": "30255479004d4355e719a9a6edd320ea",
"assets/assets/audio/pronunciation/uk_horobets.mp3": "7468ae24584f01e77c225ca6dbd706d7",
"assets/assets/audio/pronunciation/uk_re.mp3": "3a56b408bbcf0f7b249894aec9644d8c",
"assets/assets/audio/pronunciation/uk_hru.mp3": "8fe0f450ce6c741e0d5fdc8b3816102c",
"assets/assets/audio/pronunciation/uk_ravlyk.mp3": "6a7b327374decc318c1b132d5fda21e0",
"assets/assets/audio/pronunciation/uk_rot.mp3": "02ae2d093494bd81b70f1c7c86efd239",
"assets/assets/audio/pronunciation/uk_murakhy.mp3": "f0de4364e30493981916a2e07f6db34c",
"assets/assets/audio/pronunciation/uk_far.mp3": "ba79b79f5bee21fb31cbdd30ce8129fe",
"assets/assets/audio/pronunciation/uk_ruka.mp3": "d4e49a287feae44f1636ab13938e71be",
"assets/assets/audio/pronunciation/uk_hroshi.mp3": "a1d2158b9707b674fda56353462bfef4",
"assets/assets/audio/pronunciation/uk_bereza.mp3": "8c09aa2f31e0cc4098c5f4412b68c63a",
"assets/assets/audio/pronunciation/uk_kora.mp3": "03a62d288f92992afac14c9eaf909e63",
"assets/assets/audio/pronunciation/uk_hro.mp3": "e41e0f6f987acaa0aa6d8cc13c86b75a",
"assets/assets/audio/pronunciation/uk_bober.mp3": "f20d4df71ce8b59f3dbd668e23b34aa9",
"assets/assets/audio/pronunciation/uk_hry.mp3": "34b2dcaf57f6fbd233be4243102c379d",
"assets/assets/audio/pronunciation/uk_rji.mp3": "c7d32edf03358216a15e5b251ccab34f",
"assets/assets/audio/pronunciation/uk_rosa.mp3": "6b264c9d12927e8940afe36995fe7560",
"assets/assets/audio/pronunciation/uk_rjuk.mp3": "ae188451f7266d4517b2f6e3775c0d1b",
"assets/assets/audio/pronunciation/uk_robot.mp3": "fc27ba891c5e9d681cb481241a715c8a",
"assets/assets/audio/pronunciation/uk_ruch.mp3": "6b0fca04c1621a67e95792ad0858355b",
"assets/assets/audio/pronunciation/uk_ri.mp3": "6bc8850406eff33d4f60069632055880",
"assets/assets/audio/pronunciation/uk_rjak.mp3": "935bdf1106eb86f214857b1384147231",
"assets/assets/audio/pronunciation/uk_korona.mp3": "f93edd9f215cb5152d7e285716717318",
"assets/assets/audio/pronunciation/uk_rusalka.mp3": "cac76bdee02d713281ac9d7073692453",
"assets/assets/audio/pronunciation/uk_rama.mp3": "34440a2d0d29f6cfc1ddcd893de123a5",
"assets/assets/audio/failure.mp3": "020d440f85a04577ec073454b1b2974a",
"assets/assets/audio/tr_dokuz.mp3": "487f68577538dfaf2abef2575f8524e7",
"assets/assets/audio/tr_iki.mp3": "52c3af27023623da4112f34c21c5f685",
"assets/assets/audio/devjat.mp3": "c44e1cf5f31cca6db9c8eae17e0fb30a",
"assets/assets/audio/dva.mp3": "d74d110ba3425b4eb333bb88a84c77dc",
"assets/AssetManifest.bin": "db31817f8f13be6214711dc6cfefa4e9",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size4-Regular.ttf": "85554307b465da7eb785fd3ce52ad282",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Bold.ttf": "46b41c4de7a936d099575185a94855c4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Italic.ttf": "d89b80e7bdd57d238eeaa80ed9a1013a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Script-Regular.ttf": "55d2dcd4778875a53ff09320a85a5296",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Typewriter-Regular.ttf": "87f56927f1ba726ce0591955c8b3b42d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Bold.ttf": "9eef86c1f9efa78ab93d41a0551948f7",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Regular.ttf": "5a5766c715ee765aa1398997643f1589",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size1-Regular.ttf": "1e6a3368d660edc3a2fbbe72edfeaa85",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-BoldItalic.ttf": "e3c361ea8d1c215805439ce0941a1c8d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Italic.ttf": "ac3b1882325add4f148f05db8cafd401",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size3-Regular.ttf": "e87212c26bb86c21eb028aba2ac53ec3",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_AMS-Regular.ttf": "657a5353a553777e270827bd1630e467",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Regular.ttf": "dede6f2c7dad4402fa205644391b3a94",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Bold.ttf": "ad0a28f28f736cf4c121bcb0e719b88a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Bold.ttf": "a9c8e437146ef63fcd6fae7cf65ca859",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-Italic.ttf": "a7732ecb5840a15be39e1eda377bc21d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Regular.ttf": "b5f967ed9e4933f1c3165a12fe3436df",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size2-Regular.ttf": "959972785387fe35f7d47dbfb0385bc4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-BoldItalic.ttf": "946a26954ab7fbd7ea78df07795a6cbc",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Regular.ttf": "7ec92adfa4fe03eb8e9bfb60813df1fa",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"index.html": "1a909a471e1f15063227a0b5ab327ddc",
"/": "1a909a471e1f15063227a0b5ab327ddc"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
