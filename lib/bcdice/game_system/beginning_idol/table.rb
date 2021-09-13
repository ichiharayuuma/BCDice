# frozen_string_literal: true

module BCDice
  module GameSystem
    class BeginningIdol < Base
      private

      BadStatusTable = DiceTable::Table.new(
        "変調",
        "1D6",
        [
          "「不穏な空気」　PCの【メンタル】が減少するとき、減少する数値が1点上昇する",
          "「微妙な距離感」　【理解度】が上昇しなくなる",
          "「ガラスの心」　PCのファンブル値が1点上昇する",
          "「怪我」　幕間のとき、プロデューサーは「回想」しか行えない",
          "「信じきれない」　PC全員の【理解度】を1点低いものとして扱う",
          "「すれ違い」　PCはアイテムの使用と、リザルトフェイズに「おねがい」をすることができなくなる",
        ]
      )

      SkillTable = DiceTable::SaiFicSkillTable.new(
        [
          ["身長", ["～125", "131", "136", "141", "146", "156", "166", "171", "176", "180", "190～"]],
          ["属性", ["エスニック", "ダーク", "セクシー", "フェミニン", "キュート", "プレーン", "パッション", "ポップ", "バーニング", "クール", "スター"]],
          ["才能", ["異国文化", "スタイル", "集中力", "胆力", "体力", "笑顔", "運動神経", "気配り", "学力", "セレブ", "演技力"]],
          ["キャラ", ["中二病", "ミステリアス", "マイペース", "軟派", "語尾", "キャラ分野の空白", "元気", "硬派", "物腰丁寧", "どじ", "ばか"]],
          ["趣味", ["オカルト", "ペット", "スポーツ", "おしゃれ", "料理", "趣味分野の空白", "ショッピング", "ダンス", "ゲーム", "音楽", "アイドル"]],
          ["出身", ["沖縄", "九州地方", "四国地方", "中国地方", "近畿地方", "中部地方", "関東地方", "北陸地方", "東北地方", "北海道", "海外"]],
        ]
      )

      class SkillGetTable < DiceTable::Table
        def roll(randomizer)
          chosen = super(randomizer)

          m = /身長分野、(属性|才能)分野、出身分野が出たら振り直し/.match(chosen.body)
          unless m
            return chosen
          end

          reroll_category = ["身長", m[1], "出身"]
          body = chosen.body + "\n"
          loop do
            skill = SkillTable.roll_skill(randomizer)
            body += "特技リスト ＞ [#{skill.category_dice},#{skill.row_dice}] ＞ #{skill}"
            unless reroll_category.include?(skill.category_name)
              break
            end

            body += " ＞ 振り直し\n"
          end

          DiceTable::RollResult.new(chosen.table_name, chosen.value, body)
        end
      end

      TABLE = {
        "SGT" => SkillGetTable.new(
          "アイドルスキル修得表(チャレンジガールズ)",
          "1D6",
          [
            "シーンプレイヤーが修得している才能分野の特技が指定特技のアイドルスキル",
            "シーンプレイヤーが修得しているキャラ分野の特技が指定特技のアイドルスキル",
            "シーンプレイヤーが修得している趣味分野の特技が指定特技のアイドルスキル",
            "ランダムに決定した特技が指定特技のアイドルスキル(身長分野、属性分野、出身分野が出たら振り直し)",
            "《メンタルアップ》《パフォーマンスアップ》《アイテムアップ》のうちいずれか1つ",
            "《メンタルアップ》《パフォーマンスアップ》《アイテムアップ》のうちいずれか1つ",
          ]
        ),
        "RS" => SkillGetTable.new(
          "アイドルスキル修得表(ロードトゥプリンス)",
          "1D6",
          [
            "シーンプレイヤーが修得している属性分野の特技が指定特技のアイドルスキル",
            "シーンプレイヤーが修得しているキャラ分野の特技が指定特技のアイドルスキル",
            "シーンプレイヤーが修得している趣味分野の特技が指定特技のアイドルスキル",
            "ランダムに決定した特技が指定特技のアイドルスキル(身長分野、才能分野、出身分野が出たら振り直し)",
            "《メンタルディフェンス》《判定アップ》《個性アップ》のうちいずれか1つ",
            "《メンタルディフェンス》《判定アップ》《個性アップ》のうちいずれか1つ",
          ]
        ),
        "CBT" => DiceTable::D66Table.new(
          "キャラ空白表(チャレンジガールズ)",
          D66SortType::ASC,
          {
            11 => "変わった言葉遣い",
            12 => "口ぐせ",
            13 => "動物っぽい",
            14 => "和風",
            15 => "お調子者",
            16 => "計算高い",
            22 => "妹／姉キャラ",
            23 => "ポジティブ！",
            24 => "ネガティブ……",
            25 => "やんちゃ",
            26 => "年齢",
            33 => "きぐるみ",
            34 => "負けず嫌い",
            35 => "努力家",
            36 => "語りたがり",
            44 => "天然",
            45 => "物まね",
            46 => "特徴なし",
            55 => "直感",
            56 => "ピアノ",
            66 => "大切な人",
          }
        ),
        "RCB" => DiceTable::D66Table.new(
          "キャラ空白表(ロードトゥプリンス)",
          D66SortType::ASC,
          {
            11 => "悩み多し",
            12 => "俺様",
            13 => "弟系",
            14 => "がんばり屋",
            15 => "物静か",
            16 => "不器用",
            22 => "二重人格",
            23 => "ラッキーボーイ",
            24 => "愛され系",
            25 => "小悪魔",
            26 => "のほほん",
            33 => "静かな狂気",
            34 => "肉体派",
            35 => "ポエマー",
            36 => "おせっかい",
            44 => "恋愛好き",
            45 => "おかん",
            46 => "批評家",
            55 => "孤高",
            56 => "兄貴分",
            66 => "女嫌い",
          }
        ),
        "HBT" => DiceTable::D66Table.new(
          "趣味空白表(チャレンジガールズ)",
          D66SortType::ASC,
          {
            11 => "無趣味",
            12 => "ティータイム",
            13 => "詩",
            14 => "資格修得",
            15 => "イラスト",
            16 => "ぬいぐるみ",
            22 => "睡眠",
            23 => "長電話",
            24 => "メール",
            25 => "昆虫採集",
            26 => "編み物",
            33 => "食事",
            34 => "散歩",
            35 => "天体観測",
            36 => "カフェ巡り",
            44 => "お風呂",
            45 => "小物コレクション",
            46 => "ガーデニング",
            55 => "登山",
            56 => "歴史マニア",
            66 => "家事",
          }
        ),
        "RHB" => DiceTable::D66Table.new(
          "趣味空白表(ロードトゥプリンス)",
          D66SortType::ASC,
          {
            11 => "鉄道",
            12 => "華道",
            13 => "旅行",
            14 => "日曜大工",
            15 => "習字",
            16 => "俳句",
            22 => "食べ歩き",
            23 => "筋トレ",
            24 => "工作",
            25 => "資格修得",
            26 => "釣り",
            33 => "街歩き",
            34 => "ファッション",
            35 => "飼育",
            36 => "いたずら",
            44 => "街でナンパ",
            45 => "読書",
            46 => "家事全般",
            55 => "昆虫採集",
            56 => "アート",
            66 => "睡眠",
          }
        ),
        "RU" => DiceTable::Table.new(
          "マスコット暴走表",
          "1D6",
          [
            "激しいアクションで興味を持った人たちを呼び寄せる。\nPC全員の【獲得ファン人数】が5点上昇する。",
            "マスコットキャラクターから聞こえてはいけない音が聞こえてきて、次の瞬間には動かなくなってしまった。\nこのセッションの間、マスコットキャラクターが使用できなくなる。",
            "マスコットキャラクターが行方不明！　プロデューサーが代わりに着ぐるみを着たけれども、負担が大きかった。\n変調「怪我」が発生する。",
            "マスコットキャラクターが不適切な発言をしてしまい、連帯責任で謝罪することになってしまう。\nPC全員の【獲得ファン人数】が、それぞれ5点減少する。",
            "マスコットキャラクターが転んで起き上がれなくなってしまった！　みんなで力を合わせて助け起こそう。\nPC全員の【メンタル】が3点減少する。",
            "マスコットが突然PCに物申す。問題点を挙げて、鍛えてくれる。\nPC一人は、「アイドルスキル修得表」を使って、アイドルスキルを一つ修得する。",
          ]
        ),
        "SIP" => DiceTable::Table.new(
          "かんたんパーソン表",
          "1D6",
          [
            "テレビ番組に出て、ライブの宣伝をする。",
            "ラジオに出演して、ライブの宣伝をする。",
            "動画を配信して、ライブの宣伝をする。",
            "ライブの宣伝のために、街でビラ配りをする。",
            "ライブに人を集めるために、派手なパフォーマンスを街中でする。",
            "ライブの宣伝のために、あちこちを走り回る。",
          ]
        ),
        "BU" => DiceTable::Table.new(
          "バースト表",
          "1D6",
          [
            "熱い！　熱い！\n【メンタル】が2点減少する。",
            "慌てて浴槽から出ようとしたが、足を滑らせて浴槽に落ちる。ウケたはいいが、とても熱い。\n【メンタル】が1D6点減少し、【獲得ファン人数】が3D6点上昇する。",
            "温かい目で見守っていた仲間の手を力いっぱい引っ張り、浴槽に引きずり込む。\n自分以外のPCを一人選ぶ。選ばれたPCは、【メンタル】を3点減少させ、「バーストタイム」を行う。",
            "あまりの熱さに浴槽へ入り損ねていたら、仲間の一人に叩き落とされる。\n【メンタル】を2点減少してから、PCを一人選ぶ。選んだPCに対する【理解度】が3点上昇し、チェックを外す。",
            "思い切って氷を頭から浴びる。クールダウン完了！\n【メンタル】を2点減少させることで、もう一度「バーストタイム」を行うことができる。",
            "熱湯風呂に入るための着替えに手間取ってしまい、急かされてしまう。結果、満足に着替えができなかった。\nこのライブフェイズの間、衣装の効果が無効化される。",
          ]
        ),
      }.freeze

      def roll_other_table(command)
        case command
        when "RE"
          title = "ランダムイベント"

          number = @randomizer.roll_once(6)
          if number.even?
            name = "オンイベント表"
            table = [
              [11, "雨女は誰？", 96],
              [12, "千客万来☆アイドル喫茶", 97],
              [13, "フチドル", 98],
              [14, "生放送は踊る", 99],
              [15, "貸し切りプールの誘惑", 100],
              [16, "ケーオンストリート！", 101],
              [21, "アイドル×アニメ×ドリーマー！", 102],
              [22, "一日警察署長、緊急出動!?", 103],
              [23, "アイドルフィン！", 104],
              [24, "「カラオケ採点ガチバトル☆」", 105],
              [25, "「大正乙女ろまんてぃっく」", 106],
              [26, "鳩時計ラジオ", 107],
              [31, "「ガチ学院」ＣＭ", 108],
              [32, "「カラフルアイスクリーム」モデル", 109],
              [33, "忙しすぎる毎日", 110],
              [34, "悩める新人デザイナー", 112],
              [35, "「スクール☆ライフ」", 113],
              [36, "魔法のように", 114],
              [41, "食レポとその後", 115],
              [42, "ソロライブ！", 116],
              [43, "お昼の放送", 117],
              [44, "文化祭！", 118],
              [45, "商店街を救え！", 120],
              [46, "二つの仕事", 121],
              [51, "温泉にて", 122],
              [52, "アイドル探偵と豪華客船", 124],
              [53, "のうぎょう", 125],
              [54, "コント撮影", 127],
              [55, "アイドルＶＳサメ", 128],
              [56, "駅前で歌う", 130],
              [61, "街の清掃ボランティア", 131],
              [62, "ミニユニット活動", 132],
              [63, "カブトムシ狩り", 134],
              [64, "ポスター作り", 135],
              [65, "メロディ", 136],
              [66, "さいてい新聞部の取材", 138],
            ]
          else
            name = "オフイベント表"
            table = [
              [11, "アイドル、未知との遭遇", 139],
              [12, "神様おねがい！", 140],
              [13, "プチ合宿の罠!?", 141],
              [14, "どこかで会ったような……", 142],
              [15, "アイデンティティがっ！", 143],
              [16, "ホリダシ×オオソウジ", 144],
              [21, "エンドレス!?　握手会", 146],
              [22, "不安な路線変更", 147],
              [23, "全力ねこレース", 148],
              [24, "恐怖の再テスト！", 149],
              [25, "たくさんのファンレター", 150],
              [26, "夕暮れの帰り道。", 152],
              [31, "どきどき♪　調理実習", 153],
              [32, "超アイドル衣装？", 154],
              [33, "おもいでの修学旅行", 156],
              [34, "アルバイト！", 158],
              [35, "ドライブしよう！", 159],
              [36, "ファミレス攻防戦", 160],
              [41, "総合練習", 162],
              [42, "歌声はお腹から", 164],
              [43, "メイクレッスン基本から", 165],
              [44, "怪我", 166],
              [45, "エゴサ", 168],
              [46, "喫茶店でひと息", 169],
              [51, "天体観測ツアー", 170],
              [52, "謎のコーチ", 172],
              [53, "屋上にて", 174],
              [54, "クラスメイトより", 176],
              [55, "最強アイドル伝", 177],
              [56, "イメチェンしよう", 178],
              [61, "郊外ショッピング施設", 179],
              [62, "お見舞い", 180],
              [63, "ライブを観よう！", 181],
              [64, "頂を目指す", 182],
              [65, "重いコンダラ", 183],
              [66, "アイドル改造計画", 184],
            ]
          end

          dice = @randomizer.roll_d66(D66SortType::NO_SORT)
          outcome, text, page = table.assoc(dice)
          return "#{title} ＞ (1D6) ＞ #{number}\n#{name} ＞ [#{outcome}] ＞ #{text}（『ビギニングロード』#{page}ページ）"

        when "HA"
          title = "ハプニング表"
          table = [
            [11, "ハプニングなし", ""],
            [12, "ハプニングなし", ""],
            [13, "ハプニングなし", ""],
            [14, "ハプニングなし", ""],
            [15, "ハプニングなし", ""],
            [16, "ハプニングなし", ""],
            [22, "パートナープレイヤーに、地方からオファーが来た。その土地独特の文化を学んで、パートナープレイヤーに伝えよう。", "AT6"],
            [23, "グラビア撮影だが、用意された衣装のサイズがパートナープレイヤーに合わなかった。何とかして、衣装を合わせなければいけない。", "パートナープレイヤーが修得している身長分野の特技"],
            [24, "ダンス撮影中。パートナープレイヤーのダンスに迷いが見えた。何かアドバイスをして、迷いを取り払いたい。", "《ダンス／趣味9》"],
            [25, "歌の仕事だが、パートナープレイヤーの歌がどこかぎこちない。うまく本来の歌を取り戻させよう。", "パートナープレイヤーが修得している属性分野の特技"],
            [26, "体力を消費する仕事の最中に、パートナープレイヤーが倒れてしまった！　急いで処置をしなければ！", "《気配り／才能9》"],
            [33, "パートナープレイヤーにマイナースポーツのCMが回ってきたが、知らない様子だ。ルールを教えよう。", "《スポーツ／趣味4》"],
            [34, "パートナープレイヤーのキャラに合わない仕事が舞い込んだ。演技力で乗り切ってほしい。", "《演技力／才能12》"],
            [35, "パートナープレイヤーが風邪をひいてしまう。次の仕事までに、なんとか治してもらわなければ。", "《元気／キャラ8》"],
            [36, "パートナープレイヤーの属性らしくない衣装が来てしまった。うまくアレンジできればいいけど。", "《おしゃれ／趣味5》"],
            [44, "パートナープレイヤーのテンションが低い。テンションを上げるようなことを言おう。", "《バーニング／属性10》"],
            [45, "パートナープレイヤーの仕事に必要な小道具が足りなくなった。調達しよう。", "《ショッピング／趣味8》"],
            [46, "パートナープレイヤーに外国から仕事が舞い込んできた。外国の文化に合わせた仕事をしなければ。", "《異国文化／才能2》"],
            [55, "パートナープレイヤーに大会社からの仕事のオファーがやって来る。プレッシャーに負けないように後押ししよう。", "《胆力／才能5》"],
            [56, "パートナープレイヤーと他のアイドルグループとのコラボイベントが行われる。そのアイドルの情報を集めてこよう。", "《アイドル／趣味12》"],
            [66, "パートナープレイヤーの周りで、幽霊騒ぎが起こる。安心させるためにも、調査に乗り出そう。", "《オカルト／趣味2》"],
          ]
          return textFromD66Table(title, table)
        end

        TABLE[command]&.roll(@randomizer)
      end
    end
  end
end
