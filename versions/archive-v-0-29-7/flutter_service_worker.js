'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"index.html": "a76d83915bdee5f1f9f48897ef1a2091",
"/": "a76d83915bdee5f1f9f48897ef1a2091",
"flutter_bootstrap.js": "f7546e99cde8befef99f17201523fb9c",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/FontManifest.json": "f9097450010bd82cf16bb016ba2219d8",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "fcb76d7fe1d201b261528ec2bc6f6039",
"assets/NOTICES": "00a6fbf0230fb3fb97337108597be754",
"assets/assets/audio/devjat.mp3": "c44e1cf5f31cca6db9c8eae17e0fb30a",
"assets/assets/audio/failure.mp3": "020d440f85a04577ec073454b1b2974a",
"assets/assets/audio/sim.mp3": "35b64c58a75c0ba9d9346fd98a825e46",
"assets/assets/audio/pronunciation/mi.mp3": "7c5f63f84c79b9650ef9dac1823234d7",
"assets/assets/audio/pronunciation/li.mp3": "c7ff2fafdc9da0d96ea836df6b905dd7",
"assets/assets/audio/pronunciation/im.mp3": "82828e5e9c596996482bdc08ef969d1f",
"assets/assets/audio/pronunciation/pe.mp3": "e6cd78d6e29c6a0387da26d781bfca79",
"assets/assets/audio/pronunciation/uk_korabel.mp3": "28d0220a215ecc539c0e2a956418425a",
"assets/assets/audio/pronunciation/hy.mp3": "2b8456eedc7a86a4ee80e62ad9013197",
"assets/assets/audio/pronunciation/dja.mp3": "5b2796f2c4c8279d10f9cfcba174a6f7",
"assets/assets/audio/pronunciation/uk_rot.mp3": "02ae2d093494bd81b70f1c7c86efd239",
"assets/assets/audio/pronunciation/khy.mp3": "b59429beb58cc96e3a299f9558b41cf2",
"assets/assets/audio/pronunciation/lju.mp3": "4b361906c87392622d15b3a15619ba61",
"assets/assets/audio/pronunciation/fu.mp3": "6a02c92baf535dec182496c3b08997a0",
"assets/assets/audio/pronunciation/vy.mp3": "5ec91babdd8939783f830b39791492fc",
"assets/assets/audio/pronunciation/uk_bereza.mp3": "8c09aa2f31e0cc4098c5f4412b68c63a",
"assets/assets/audio/pronunciation/cho.mp3": "8932ccf7ccd0285b31eb095b3ba8f293",
"assets/assets/audio/pronunciation/dju.mp3": "db5d4de1aa4b858d444ac4fab780f28a",
"assets/assets/audio/pronunciation/kit.mp3": "5a730909ff669863c84b8e2ab1822d5d",
"assets/assets/audio/pronunciation/uk_hrusha.mp3": "33766829de2cb39bfd3860d961bea0f8",
"assets/assets/audio/pronunciation/da.mp3": "659cf85ae798b4f7ecc7662a7f9c5906",
"assets/assets/audio/pronunciation/dro.mp3": "5f90fd2cbbdd41987c076dfe59c504d5",
"assets/assets/audio/pronunciation/sa.mp3": "0465e1deebc4b6c0e27440b00234ae00",
"assets/assets/audio/pronunciation/om.mp3": "00e40da7b1fe51a13b8610afd7daaca2",
"assets/assets/audio/pronunciation/husy.mp3": "8034bd746f433cb5a0609448910c76a0",
"assets/assets/audio/pronunciation/ma.mp3": "20d7946b30f80488d678efbff326544e",
"assets/assets/audio/pronunciation/ky.mp3": "0f456b179fae81f5f20d52416639858b",
"assets/assets/audio/pronunciation/sha.mp3": "3c0dbbe5ce574c8cdea4f38656712d0b",
"assets/assets/audio/pronunciation/khu.mp3": "90073aa5a74a8064fb5d73716f0b1a08",
"assets/assets/audio/pronunciation/kro.mp3": "dfa3d8d668fea39d5e1d0adb5d887050",
"assets/assets/audio/pronunciation/lu.mp3": "02069249a8cd77f2af4282d0e5bc63b0",
"assets/assets/audio/pronunciation/uk_ravlyk.mp3": "6a7b327374decc318c1b132d5fda21e0",
"assets/assets/audio/pronunciation/on.mp3": "9ad1cd79e9ae27ac25c4cc247c36fee2",
"assets/assets/audio/pronunciation/zhu.mp3": "a8072e847b5fd9197e84de464eb5fa74",
"assets/assets/audio/pronunciation/lo.mp3": "b3f3bc9d9842938696c26387b44527bb",
"assets/assets/audio/pronunciation/uk_rjukzak.mp3": "e93f0eec3bea58171b499a8d9acf2a15",
"assets/assets/audio/pronunciation/ho.mp3": "dd4c4aa35d99283862f8d249901be9e9",
"assets/assets/audio/pronunciation/sho.mp3": "da6ecc6a67b2a03e191bb501d9ef8a68",
"assets/assets/audio/pronunciation/sja.mp3": "d73396fc2a7b589cd073d00f1ecbee1f",
"assets/assets/audio/pronunciation/uk_baraban.mp3": "e5fc27026cc8ae05634c46702e5793e0",
"assets/assets/audio/pronunciation/op.mp3": "cbc69df984421a2b5f0eb960b8f8f87c",
"assets/assets/audio/pronunciation/mo.mp3": "8b3ed44825595b18e2d29a8c6c8b543a",
"assets/assets/audio/pronunciation/dzy.mp3": "1ff2fb91c536760291f9c34b7a42d47a",
"assets/assets/audio/pronunciation/ny.mp3": "56a67375a7c4fad3ffc9aa57956a3f9f",
"assets/assets/audio/pronunciation/uk_ko.mp3": "30255479004d4355e719a9a6edd320ea",
"assets/assets/audio/pronunciation/uk_murakhy.mp3": "f0de4364e30493981916a2e07f6db34c",
"assets/assets/audio/pronunciation/su.mp3": "ee387cd3fb88db844ac171b2b65a42d0",
"assets/assets/audio/pronunciation/be.mp3": "ceb8d05b53fbc6705875ff2b403354a1",
"assets/assets/audio/pronunciation/no.mp3": "5a1e93474bd1556e2d11760c66bde92e",
"assets/assets/audio/pronunciation/he.mp3": "869b2a42039bba2137cc698a5b6580a2",
"assets/assets/audio/pronunciation/ob.mp3": "19b464233ef56a6f26986f75209d03e1",
"assets/assets/audio/pronunciation/uk_fartukh.mp3": "07f6998e79a1f93d62678a915f74128e",
"assets/assets/audio/pronunciation/uk_arka.mp3": "e54dbcee8f1dc4784077f3f8b8a12b91",
"assets/assets/audio/pronunciation/uk_ryba.mp3": "d181badd61a24cf11f2d4d1db606b831",
"assets/assets/audio/pronunciation/mylo.mp3": "6835e72ac01dcd9d5953f6b4cc16cfa9",
"assets/assets/audio/pronunciation/le.mp3": "4d055fb90a22e392efa612a13d84a9ab",
"assets/assets/audio/pronunciation/vi.mp3": "94e12b54a75d545f958df23f013f100b",
"assets/assets/audio/pronunciation/os.mp3": "1dcc34790718ed6069ede11d0fa3f4db",
"assets/assets/audio/pronunciation/uk_rji.mp3": "c7d32edf03358216a15e5b251ccab34f",
"assets/assets/audio/pronunciation/za.mp3": "c3bf12b6d58755f9efe8785433ed12c0",
"assets/assets/audio/pronunciation/pa.mp3": "a39834327e976d19e1d8cf117d9b664b",
"assets/assets/audio/pronunciation/mukha.mp3": "563048fffb78a7a7b3fdcf4e6a618c89",
"assets/assets/audio/pronunciation/fy.mp3": "d24361153f340092d9d299bf21668627",
"assets/assets/audio/pronunciation/uk_syr.mp3": "e3cdff9d02d9e25285ce804127366035",
"assets/assets/audio/pronunciation/zhe.mp3": "e533bbe63f1c764059bfa6caa1187dae",
"assets/assets/audio/pronunciation/uk_hro.mp3": "e41e0f6f987acaa0aa6d8cc13c86b75a",
"assets/assets/audio/pronunciation/ni.mp3": "299b37136a6a3567b97b466556ef380b",
"assets/assets/audio/pronunciation/oj.mp3": "c279e57cda3b48d1525e2346a0006809",
"assets/assets/audio/pronunciation/hre.mp3": "0bf70dd288cb4e33bd9fc6c2d93f664f",
"assets/assets/audio/pronunciation/vo.mp3": "acbea764c245caccdbccf8ac44a61f50",
"assets/assets/audio/pronunciation/aj.mp3": "19e562814ff8f1817f378d41ec90cbfd",
"assets/assets/audio/pronunciation/me.mp3": "c399ec1b357e30db230a360df0b320a6",
"assets/assets/audio/pronunciation/uk_ru.mp3": "0b1156d69b0c8624be6a9fa11c182772",
"assets/assets/audio/pronunciation/uk_robot.mp3": "fc27ba891c5e9d681cb481241a715c8a",
"assets/assets/audio/pronunciation/ir.mp3": "825b0ff92e436aff4c5c904a633af303",
"assets/assets/audio/pronunciation/pry.mp3": "972f36f0564bc552403cf5d0408da3b8",
"assets/assets/audio/pronunciation/ljo.mp3": "f857e7c0d74e8f3a102679c07d283560",
"assets/assets/audio/pronunciation/ge.mp3": "7e51503d416f40f5ec2fb8e621dc6dd9",
"assets/assets/audio/pronunciation/kry.mp3": "0887336f1abd4607366776fcccb15653",
"assets/assets/audio/pronunciation/fo.mp3": "1e154cd0b89affa66242955016b1fc51",
"assets/assets/audio/pronunciation/ti.mp3": "75a0f6b2f83bf5936196d9e65bd719fc",
"assets/assets/audio/pronunciation/pi.mp3": "a82c0e426af1e7a8ad1b8cd14cc1d65c",
"assets/assets/audio/pronunciation/my.mp3": "7cd172711ef31f6cf26775b069f4da0e",
"assets/assets/audio/pronunciation/uk_ri.mp3": "6bc8850406eff33d4f60069632055880",
"assets/assets/audio/pronunciation/pu.mp3": "807d68e6f455add33777699eb2d71ddb",
"assets/assets/audio/pronunciation/ty.mp3": "ad3531c9cbb5bfb52994efa9b1e88d5c",
"assets/assets/audio/pronunciation/she.mp3": "769c615a567a50634df64861f2e6cf84",
"assets/assets/audio/pronunciation/uk_hry.mp3": "34b2dcaf57f6fbd233be4243102c379d",
"assets/assets/audio/pronunciation/bu.mp3": "4a4bedd2236bdb10e7d8b6a9e1eef20a",
"assets/assets/audio/pronunciation/pru.mp3": "b3635bf4cccd43d7a9cf636006ec1444",
"assets/assets/audio/pronunciation/uk_hru.mp3": "8fe0f450ce6c741e0d5fdc8b3816102c",
"assets/assets/audio/pronunciation/zhi.mp3": "32e1203f38f0e5a20d915a960dd822fb",
"assets/assets/audio/pronunciation/tu.mp3": "83b5648bc8fdbbc511cd7a003539a07f",
"assets/assets/audio/pronunciation/uk_ry.mp3": "8fea95502a76a8c5ecfb5c130819afcf",
"assets/assets/audio/pronunciation/ne.mp3": "4a9a44b6541a1490421c6e8a66417d7c",
"assets/assets/audio/pronunciation/uk_rys.mp3": "53704340f9b5d07edb11f4bf69f23e34",
"assets/assets/audio/pronunciation/av.mp3": "0dd5aa314c44f77484642ee61126c788",
"assets/assets/audio/pronunciation/kha.mp3": "19b1dd5bc0734db384dfc2c8aed78bdb",
"assets/assets/audio/pronunciation/zhy.mp3": "5fc5639245bda9c7392a8c0780ccff33",
"assets/assets/audio/pronunciation/fa.mp3": "669cc2af5a9db0466dca821c79803d6e",
"assets/assets/audio/pronunciation/uk_rjak.mp3": "935bdf1106eb86f214857b1384147231",
"assets/assets/audio/pronunciation/uk_hryb.mp3": "0fdae9639bd1cd0eacb9f0b9ba065f93",
"assets/assets/audio/pronunciation/bi.mp3": "7246bb86083acca8ae53af8c24c4da85",
"assets/assets/audio/pronunciation/zju.mp3": "ac7c6de9a7fecf6da7bcd399fb336ad8",
"assets/assets/audio/pronunciation/to.mp3": "36347b1e28b8f557f7e2babf31f98ef6",
"assets/assets/audio/pronunciation/hi.mp3": "0a01fd6d3f2e90405075b43e0b0b2e4a",
"assets/assets/audio/pronunciation/uk_far.mp3": "ba79b79f5bee21fb31cbdd30ce8129fe",
"assets/assets/audio/pronunciation/uk_rysj.mp3": "05c11c435fae1c928c6e83d03a87b23f",
"assets/assets/audio/pronunciation/uk_rusalka.mp3": "cac76bdee02d713281ac9d7073692453",
"assets/assets/audio/pronunciation/shcho.mp3": "69800d7b7721a572850c7b85dbbc1c5c",
"assets/assets/audio/pronunciation/du.mp3": "1d10b141be252ac6fd8ce872d899b639",
"assets/assets/audio/pronunciation/gu.mp3": "32f34569fee1267f788e97862e320af4",
"assets/assets/audio/pronunciation/pro.mp3": "154633b38c45f1a4370f0e8204207e3b",
"assets/assets/audio/pronunciation/uk_horobets.mp3": "7468ae24584f01e77c225ca6dbd706d7",
"assets/assets/audio/pronunciation/hu.mp3": "1b27cc0f8c0f3891dc8c60a79b978367",
"assets/assets/audio/pronunciation/khe.mp3": "d865a7988e5491f0920b4e41870fbfdb",
"assets/assets/audio/pronunciation/se.mp3": "37d15aba9fe22e7090961f68e285f15c",
"assets/assets/audio/pronunciation/che.mp3": "6dec362fff05fe61843810832b45797b",
"assets/assets/audio/pronunciation/zu.mp3": "f0e36ae7b3f85eb0f862d53d04760671",
"assets/assets/audio/pronunciation/uk_rja.mp3": "386c1531a71542d34c9ad2c1c2e9b89a",
"assets/assets/audio/pronunciation/ju.mp3": "29d2e050622812e35318c726aff57733",
"assets/assets/audio/pronunciation/uz.mp3": "3712826cabe2d6696a7982336821a742",
"assets/assets/audio/pronunciation/uk_pero.mp3": "aeab1272201c14cdbfedc43bcc5db97c",
"assets/assets/audio/pronunciation/koza.mp3": "b9354b655c54aceb08a083e4570d66e0",
"assets/assets/audio/pronunciation/ha.mp3": "2c0020b34cf9a21013d3d0b1e09f5267",
"assets/assets/audio/pronunciation/uk_richka.mp3": "2f15edfc7567e314e8b55acc99f0614f",
"assets/assets/audio/pronunciation/ja.mp3": "182b3a8c5f4e168bb87780f3c8100ee8",
"assets/assets/audio/pronunciation/jo.mp3": "5a784ae1823c1f76381c534f820d737a",
"assets/assets/audio/pronunciation/uk_hroshi.mp3": "a1d2158b9707b674fda56353462bfef4",
"assets/assets/audio/pronunciation/ke.mp3": "0d24358b6a3a2b1651b6e26631bcfe73",
"assets/assets/audio/pronunciation/dre.mp3": "46adbc667913f7b7ef84400981729957",
"assets/assets/audio/pronunciation/zo.mp3": "5c260455274c145a0ded97a8c8fb320e",
"assets/assets/audio/pronunciation/uk_rosa.mp3": "6b264c9d12927e8940afe36995fe7560",
"assets/assets/audio/pronunciation/cha.mp3": "24348f6702cdaad7b0660976b09ff10a",
"assets/assets/audio/pronunciation/ji.mp3": "2dfb7fdf7d1491f14987b01d0a1ac139",
"assets/assets/audio/pronunciation/uk_ruka.mp3": "d4e49a287feae44f1636ab13938e71be",
"assets/assets/audio/pronunciation/sy.mp3": "6a6cd82dff3cfd05ee4b1534e7998eac",
"assets/assets/audio/pronunciation/dra.mp3": "5af19a9e99157d773d467b72224373a8",
"assets/assets/audio/pronunciation/uk_ruch.mp3": "6b0fca04c1621a67e95792ad0858355b",
"assets/assets/audio/pronunciation/ta.mp3": "a4013f7192dd7b4d5e034c43f33c924b",
"assets/assets/audio/pronunciation/ka.mp3": "1c8b59c02e6cff687a776152bc044fab",
"assets/assets/audio/pronunciation/uk_raketa.mp3": "7dd73894caeb4868cde60295ae0ebe98",
"assets/assets/audio/pronunciation/in.mp3": "25c7981dff1b857a2ec06b10fb330bc9",
"assets/assets/audio/pronunciation/po.mp3": "8cd0d5582bbb59050686a6902780c534",
"assets/assets/audio/pronunciation/uk_bober.mp3": "f20d4df71ce8b59f3dbd668e23b34aa9",
"assets/assets/audio/pronunciation/fi.mp3": "989676d7cea11d1704a380f77946205d",
"assets/assets/audio/pronunciation/uk_sokyra.mp3": "112c6e7795e87cb80bad3ea5c18859e5",
"assets/assets/audio/pronunciation/feja.mp3": "a29c6609fe961c64e3d7473d17088b54",
"assets/assets/audio/pronunciation/dub.mp3": "5c513801fc5bcdcdbf1ce480fb2cf811",
"assets/assets/audio/pronunciation/mu.mp3": "0e35e08c680336974e5a10d41f48e5ed",
"assets/assets/audio/pronunciation/uk_kora.mp3": "03a62d288f92992afac14c9eaf909e63",
"assets/assets/audio/pronunciation/zho.mp3": "146fa5b319a57e5d8bb773960d17e27e",
"assets/assets/audio/pronunciation/uk_rozhevyj.mp3": "511ee230ae3a66b923edd0da520c222e",
"assets/assets/audio/pronunciation/sly.mp3": "6d8b55a4e7338688e08ba57a37e33280",
"assets/assets/audio/pronunciation/dy.mp3": "e9141543f06723342a96f5e3310226d8",
"assets/assets/audio/pronunciation/uk_ruchka.mp3": "d0df3aff6dc09607c7222fdd9746eb72",
"assets/assets/audio/pronunciation/di.mp3": "aae7df7cff02262dc566a6c874074cec",
"assets/assets/audio/pronunciation/kho.mp3": "eb18b1cbbc3ff0213b1550d3f153da59",
"assets/assets/audio/pronunciation/uk_ba.mp3": "79ae72753b6486178ff1dd3694b7649f",
"assets/assets/audio/pronunciation/vu.mp3": "da54f68cb78dfdcdbc3a0288b6bae554",
"assets/assets/audio/pronunciation/uk_korova.mp3": "5a3275ca79fa7af122232e878c30e9d8",
"assets/assets/audio/pronunciation/by.mp3": "0b1c0ef5ffdbe784320c9ba8b4546e90",
"assets/assets/audio/pronunciation/ki.mp3": "edf6aa46dbf3a7fb0ca2452c9eb89bf2",
"assets/assets/audio/pronunciation/ur.mp3": "96ca02645973034ac61a86ecdf4a8b1c",
"assets/assets/audio/pronunciation/uk_rama.mp3": "34440a2d0d29f6cfc1ddcd893de123a5",
"assets/assets/audio/pronunciation/nu.mp3": "ec61bdfea4fbdd6ee1c0f3a710e2bbb2",
"assets/assets/audio/pronunciation/zha.mp3": "1214be017cf919577c5b9f7e1696c23b",
"assets/assets/audio/pronunciation/en.mp3": "46cb2bb80403a85ced2969cfc3699b3e",
"assets/assets/audio/pronunciation/de.mp3": "4229b6a6240a8f92a16f76b0d585b08f",
"assets/assets/audio/pronunciation/ga.mp3": "8dab14e9460ab41b7cb1cfe07ee0492e",
"assets/assets/audio/pronunciation/bo.mp3": "947639b4f8afb0380a91c197631bb51d",
"assets/assets/audio/pronunciation/si.mp3": "128873cc8435d39f823e6885c3b18657",
"assets/assets/audio/pronunciation/ly.mp3": "e3b57525a6c752834b74a15073a39893",
"assets/assets/audio/pronunciation/shi.mp3": "afbd5a63ae05d10d2448ff1ff12824b5",
"assets/assets/audio/pronunciation/je.mp3": "c0431d0bb2b5082eef54180cafd01332",
"assets/assets/audio/pronunciation/uk_va.mp3": "4e831d213c5943d64e41ec298661dad0",
"assets/assets/audio/pronunciation/pre.mp3": "c03107d9dc69977fb2ae8f97d554cb9a",
"assets/assets/audio/pronunciation/nja.mp3": "266823235ef714c25b81b980fa970fcd",
"assets/assets/audio/pronunciation/zja.mp3": "82370aee28e79499b2e687df60d15e7a",
"assets/assets/audio/pronunciation/nju.mp3": "f402459cd3137284ecc735b139eba127",
"assets/assets/audio/pronunciation/uk_romashka.mp3": "b14b1cc68a3d8ceaf96fb3673545c8ca",
"assets/assets/audio/pronunciation/ot.mp3": "4afd7a17c3dea80eea13d4d07b063db8",
"assets/assets/audio/pronunciation/e.mp3": "d71b8fdff2d1dfefd7328bf4b5ca4bfc",
"assets/assets/audio/pronunciation/zi.mp3": "736c309bfdc3c99c6b351377a94bb147",
"assets/assets/audio/pronunciation/shy.mp3": "7652e91d9f8fc6692fa589680d99337f",
"assets/assets/audio/pronunciation/uk_horikhy.mp3": "dd4248186da3f5d6f6c9dc9b904acb79",
"assets/assets/audio/pronunciation/uk_rjuk.mp3": "ae188451f7266d4517b2f6e3775c0d1b",
"assets/assets/audio/pronunciation/uk_arfa.mp3": "b6a97f3951c858ed3f23f61cc56c7dec",
"assets/assets/audio/pronunciation/ze.mp3": "2790cc96e1947935e4223af45a8fbadf",
"assets/assets/audio/pronunciation/ek.mp3": "9ed559b1673aca6184afe162dba16868",
"assets/assets/audio/pronunciation/uk_ar.mp3": "eaf33d8dfcdeb0a0e5da06acc343ebda",
"assets/assets/audio/pronunciation/do_syllable.mp3": "91c9ed590db8b07e7828d55250c49f0b",
"assets/assets/audio/pronunciation/sjo.mp3": "4c7448496ed35cdb091976c3d113dc0a",
"assets/assets/audio/pronunciation/lja.mp3": "1d784eca52f5e0bc59b3abca32f2e2ad",
"assets/assets/audio/pronunciation/uk_rju.mp3": "5c63c04daa5394d04e79e523a2fbfe85",
"assets/assets/audio/pronunciation/la.mp3": "4bb022447289eeb6901b68a3af66c829",
"assets/assets/audio/pronunciation/te.mp3": "1bacb223299a7bdadae4f675042d5bcd",
"assets/assets/audio/pronunciation/uk_re.mp3": "3a56b408bbcf0f7b249894aec9644d8c",
"assets/assets/audio/pronunciation/py.mp3": "57b487bf898a1052cf07a08db675e762",
"assets/assets/audio/pronunciation/fe.mp3": "c7507ed005c15dbea8bbd461dd236e17",
"assets/assets/audio/pronunciation/uk_korona.mp3": "f93edd9f215cb5152d7e285716717318",
"assets/assets/audio/pronunciation/na.mp3": "02e811e946e38e8680d30d31bffae98f",
"assets/assets/audio/pronunciation/uk_ro.mp3": "500863d8725dad30c628406e6a2a84b4",
"assets/assets/audio/pronunciation/uk_ra.mp3": "6ea8623f5a2becbb973d076b0e5b14bd",
"assets/assets/audio/pronunciation/shchu.mp3": "a7ca0f44fe3c140388ee615a493f4889",
"assets/assets/audio/pronunciation/ve.mp3": "dc60308916eb0e243857bf67bf56c22d",
"assets/assets/audio/pronunciation/so.mp3": "3824ed5bb0b9461cd03e8463f2f90c9e",
"assets/assets/audio/pronunciation/zy.mp3": "0ac02b8b52785433badab4bb078f5782",
"assets/assets/audio/tr_dokuz.mp3": "487f68577538dfaf2abef2575f8524e7",
"assets/assets/audio/tr_iki.mp3": "52c3af27023623da4112f34c21c5f685",
"assets/assets/audio/test.mp3": "aaa133b26647ab226ec6a2eb4a6fd976",
"assets/assets/audio/dva.mp3": "d74d110ba3425b4eb333bb88a84c77dc",
"assets/assets/audio/ding.mp3": "aaa133b26647ab226ec6a2eb4a6fd976",
"assets/assets/images/fish.png": "3630d1eaed228f8f451e43a3bf75a67a",
"assets/assets/images/eye.png": "fc59c8d3bb15100441d9c599b855ab99",
"assets/assets/images/food.png": "170573a5a66d7f7e2373f8ac23298725",
"assets/assets/images/peregrine.png": "2e23a71224a92bc33b97918e125f8f07",
"assets/assets/images/tasks/ellipse.png": "7b0f91eed379dc7702a0592d8812e596",
"assets/assets/images/tasks/cover.png": "f3e462c8e6785057c9585b32968747a0",
"assets/assets/images/tasks/circle.png": "027b710b994aaad87c8aff23602b66a4",
"assets/assets/images/tasks/triangle.png": "1728c96ebcadcbb4e4796c0b95d219da",
"assets/assets/images/tasks/apple.png": "645e1845325bc89e476ffa30786b34f5",
"assets/assets/images/tasks/square.png": "2fcb46e88a4e2efbfe2284c24608a790",
"assets/assets/images/cheese.png": "755dcbc784f07f7818e9015ae4b1cc32",
"assets/assets/images/geese.png": "1894175628df36c2354e28912d9a4863",
"assets/assets/images/bark.jpg": "607a7a15246f6e48f353515e5639ba11",
"assets/assets/images/cupboard.png": "ca98239a4a779dc534f9e7903d59a28e",
"assets/assets/images/emu.png": "8aee47189e12ae9c14e5590b8d020fbb",
"assets/assets/images/eyes.png": "21e3d7dd4848d3a4a09aad5b44e6e334",
"assets/assets/images/guitar.png": "14eb9980d238e28aa72b5dfbe728ed8a",
"assets/assets/images/ants.png": "db5619c4f0494152647603428839cd63",
"assets/assets/images/marlin.png": "6fc08ddb208258ca6001f5850e84182e",
"assets/assets/images/mouth.png": "bda4e91492624ab0d7b2925e00882094",
"assets/assets/images/cow.png": "28d0a01f643c31d04d5c9a92cf47161f",
"assets/assets/images/coat.png": "dee817be7dd84e3a5ade47a1921e1ebf",
"assets/assets/images/dew.png": "c0eed3628541c88a705ee2e416822ece",
"assets/assets/images/giraffe.png": "fbecaacecd717e5893a90fdd72d1e6cf",
"assets/assets/images/foam.png": "ff1a039c9653f996f3bb730efea8cd57",
"assets/assets/images/egg.png": "848ea235b1593efd31d8f7d3ddad5654",
"assets/assets/images/crown.png": "2097bbbbe2601e6389593d66fffa07ea",
"assets/assets/images/awl.png": "b46d8890e5bc952202f28757d738e15c",
"assets/assets/images/apron.png": "37118f19fe57c8ab3699bece55246d1e",
"assets/assets/images/fairy.png": "782f2f3dea85d14124e37550f752e78b",
"assets/assets/images/calf.png": "9801af655f1b4dc24aaaf804790df1c2",
"assets/assets/images/fox.png": "d74801dfbd2ebe683bf94198dd6b0f20",
"assets/assets/images/foal.png": "204fbe003eca75abc22c43a8b127bfdb",
"assets/assets/images/axe.png": "db111b584e0c99dbe25ee8db09f9cff0",
"assets/assets/images/beat.png": "9c85668a4879089bb70a703d50816951",
"assets/assets/images/cuckoo.png": "fa46a2ccd4a3ad53d71167990b938e7a",
"assets/assets/images/anchor.png": "72fff44fbd6238512cd4ad9a312d81a1",
"assets/assets/images/ear.png": "6a05b4157985a41736072ff3f4ac04dd",
"assets/assets/images/duckling.png": "27bbd91611f1b1a5a08031ba9819a17e",
"assets/assets/images/arm.png": "d32c27ae522ab8fa9ca68d640902beec",
"assets/assets/images/river.png": "7d398ad602da55c330eb35aebc8cb6e2",
"assets/assets/images/gate.png": "593c161962c77354540002dd2ac6f835",
"assets/assets/images/frame.jpg": "1f821ba4c2bc03b1e758c42b59357150",
"assets/assets/images/frog.png": "0634d947ca7c4a799a50601fbd26c960",
"assets/assets/images/birch.png": "022a2f604ab47f6a767aca1c3f5fcc48",
"assets/assets/images/goat.png": "197b078e719889dc8b1ab21dfa2271a6",
"assets/assets/images/ant.png": "1f8802be44cc138586e5c64b14e89cbd",
"assets/assets/images/horns.png": "30354a2c2fc2fe64c6db063c121df524",
"assets/assets/images/fly.png": "6f57e37fc73fdeb16bbebaea6fad7005",
"assets/assets/images/arc.png": "4a49373df0832bc633c3390fb7914a46",
"assets/assets/images/cheetah.png": "03a87c3189a07bddfb180f1fedc7aa85",
"assets/AssetManifest.bin": "ea2ae58f24f37db8d61a545e77f2289f",
"assets/AssetManifest.bin.json": "17dbfd06e56fac8ff217a2e744ec4e40",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Regular.ttf": "5a5766c715ee765aa1398997643f1589",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Italic.ttf": "d89b80e7bdd57d238eeaa80ed9a1013a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Regular.ttf": "b5f967ed9e4933f1c3165a12fe3436df",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-BoldItalic.ttf": "946a26954ab7fbd7ea78df07795a6cbc",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Bold.ttf": "a9c8e437146ef63fcd6fae7cf65ca859",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size2-Regular.ttf": "959972785387fe35f7d47dbfb0385bc4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size4-Regular.ttf": "85554307b465da7eb785fd3ce52ad282",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Bold.ttf": "ad0a28f28f736cf4c121bcb0e719b88a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Bold.ttf": "46b41c4de7a936d099575185a94855c4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size1-Regular.ttf": "1e6a3368d660edc3a2fbbe72edfeaa85",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Script-Regular.ttf": "55d2dcd4778875a53ff09320a85a5296",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-Italic.ttf": "a7732ecb5840a15be39e1eda377bc21d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Regular.ttf": "dede6f2c7dad4402fa205644391b3a94",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Regular.ttf": "7ec92adfa4fe03eb8e9bfb60813df1fa",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size3-Regular.ttf": "e87212c26bb86c21eb028aba2ac53ec3",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_AMS-Regular.ttf": "657a5353a553777e270827bd1630e467",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-BoldItalic.ttf": "e3c361ea8d1c215805439ce0941a1c8d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Typewriter-Regular.ttf": "87f56927f1ba726ce0591955c8b3b42d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Bold.ttf": "9eef86c1f9efa78ab93d41a0551948f7",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Italic.ttf": "ac3b1882325add4f148f05db8cafd401",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"manifest.json": "7e1c66951ac8258e84bc86d32f6e5f1e",
"version.json": "dccd776b9d5624e17d6aee1dcac257c5",
"main.dart.js": "0a98857db6361076b37b323d682700e2"};
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
