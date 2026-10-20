//!MainActivity.GAME_MODE
/*package com.uazamula.syllables_v0_3;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import android.annotation.SuppressLint;
import android.content.ClipData;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Point;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.util.TypedValue;
import android.view.Display;
import android.view.DragEvent;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicInteger;

import static com.uazamula.syllables_v0_3.MainActivity.IS_TALE;
import static com.uazamula.syllables_v0_3.MainActivity.IS_TOPIC;
import static com.uazamula.syllables_v0_3.AlphabetActivity.syllables;
import static com.uazamula.syllables_v0_3.MainActivity.IS_VANILLA_OR_HIGHER;
import static com.uazamula.syllables_v0_3.MainActivity.LANGUAGE_ID;

import com.uazamula.syllables_v0_3.utils.SplitText;

public class SyllableDetailActivity extends AppCompatActivity implements GestureDetector.OnGestureListener {

  public static final String EXTRA_SYLLABLES_ID = "array_of_syllables_ID";
  public static final String SYLLABLE_COUNT = "syllableCount";// We should use the combination of the keys

  public static final int SWIPE_TRESHOLD = 100;
  public static final int SWIPE_VELOCITY_TRESHOLD = 100;
  public static final float COEF_FOR_TABLET = 1.35f;
  public static final float COEF_FOR_TABLET_XL = 1.7f;

  public static int SKIP_PURE_SYLLABLES = 0;//deprecated, don't touch

  public static boolean SHOW_NATIVE_WORDS;
  public static boolean SPLIT_BY_SYLLABLES;
  public static boolean IMAGE_IS_HIDDEN;

  public static int CURRENT_LETTER;
  public static int CURRENT_WORD;

  public static int CURRENT_LETTER_TOPIC;
  public static int CURRENT_WORD_TOPIC;

  public static float DIFFICULTY_LEVEL_MIN;// RangeSlider
  public static float DIFFICULTY_LEVEL_MAX;// RangeSlider
  public static final float[] LEVELS_OF_DIFFICULTIES_FLOAT = {0f, 1f, 2f, 3f};// RangeSlider
  public static final int[] LEVELS_OF_DIFFICULTIES_ID = {R.string.level_easy, R.string.level_normal, R.string.level_hard, R.string.level_reader};// RangeSlider

  private int countSyllables;
  private int syllableId = 0;
  private int letterId = 0;
  private boolean IMAGE_ALREADY_CLICKED;

  private ArrayList<Integer> listOfSyllablesId;

  private List<TextView> slots = new ArrayList<>();
  private LinearLayout syllable_detail;
  @SuppressLint("NewApi")
  private final List<Integer> slotIDs = List.of(R.id.syllable1, R.id.syllable2, R.id.syllable3, R.id.syllable4, R.id.syllable5);

  List<TextView> draggedItems = new ArrayList<>();
  @SuppressLint("NewApi")
  private final List<Integer> draggedItemIDs = List.of(R.id.s_from1, R.id.s_from2, R.id.s_from3, R.id.s_from4, R.id.s_from5, R.id.s_from6, R.id.s_from7);

  List<ImageView> stars = new ArrayList<>();
  @SuppressLint("NewApi")
  private final List<Integer> starIDs = List.of(R.id.star1, R.id.star2, R.id.star3, R.id.star4, R.id.star5, R.id.star6, R.id.star7, R.id.star8, R.id.star9, R.id.star10, R.id.star11, R.id.star12);

  List<String> syllablesForChoose = new ArrayList<>();
  List<String> syllablesForWord = new ArrayList<>();
  List<Boolean> areDropped = new ArrayList<>();

  // TODO з поверненням!
  public static boolean SYLLABLES_IN_ORDER;
  int numOfFilledSlots = 0;
  List<Handler> handler = List.of(new Handler(Looper.myLooper()), new Handler(Looper.myLooper()),
      new Handler(Looper.myLooper()), new Handler(Looper.myLooper()),
      new Handler(Looper.myLooper()), new Handler(Looper.myLooper()));
  boolean isRunAllSyllables = false;

  ImageView buttonNext;
  ImageView buttonPrev;

  SettingsActivity settingsActivity = new SettingsActivity();

  private MediaPlayer mp;
  private GestureDetector gestureDetector;

  LinearLayout linearLayout;
  public List<LinearLayout> linearLayouts = new ArrayList<>();
  List<TextView> listOfTextViewElements;

  static final int SAFE_ZONE = 1;// and 12 - for tablets

  private boolean areLetters(String str) {
    return !str.contains(" ") &&
        !str.contains(".") && !str.contains(",") &&
        !str.contains("!") && !str.contains("?") &&
        !str.contains("-") && !str.contains("\"") &&
        !str.contains(";") && !str.contains(":");
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(IS_TALE ? R.layout.activity_tale : R.layout.activity_syllable_detail);

    if (IS_VANILLA_OR_HIGHER &&  !IS_TALE) {
      syllable_detail=findViewById(R.id.syllable_detail);
      syllable_detail.setPadding(10,40,10,30);
    }

    listOfSyllablesId = getIntent().getIntegerArrayListExtra(EXTRA_SYLLABLES_ID);
    countSyllables = getIntent().getIntExtra(SYLLABLE_COUNT, 0);

    syllableId = listOfSyllablesId.get(countSyllables);

    if (syllables == null) {

      Intent intent = new Intent(this, MainActivity.class);
      startActivity(intent);
      return;

    }
    letterId = syllables[syllableId].getLetterId();
    //Set a word
    String word;
    if (SPLIT_BY_SYLLABLES || MainActivity.GAME_MODE)
      word = syllables[syllableId].getWordSplitted();
    else
      word = syllables[syllableId].getWord();

    buttonNext = findViewById(R.id.arrow_game_next);
    buttonPrev = findViewById(R.id.arrow_game_prev);
    //Set an image
    int clickMe = R.drawable.click;
    int wordImage = syllables[syllableId].getImageResourceId();
    int imageIs = IMAGE_IS_HIDDEN ? clickMe : wordImage;

    ImageView imageView = findViewById(R.id.image_with_this_syllable);
    imageView.setImageDrawable(ContextCompat.getDrawable(this, imageIs));
    imageView.setContentDescription(word);

    imageView.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
    if (!IMAGE_ALREADY_CLICKED) {
    imageView.setImageDrawable(ContextCompat.getDrawable(SyllableDetailActivity.this, wordImage));
    }

    makeMPNull();
    int sound = syllables[syllableId].getSoundResourceId();
    mp = MediaPlayer.create(SyllableDetailActivity.this, sound);
    if (IMAGE_ALREADY_CLICKED || !IMAGE_IS_HIDDEN) {
    mp.start();

    }

    IMAGE_ALREADY_CLICKED = true;
    }
    });

    buttonNext.setOnClickListener(v -> goToNextSyllable());
    buttonPrev.setOnClickListener(v -> gotoPrevSyllable());
    gestureDetector = new GestureDetector(this, this);

    if (IS_TALE) {
    placeSplitText(word);
    return;
    }

    for (int i = 0; i < slotIDs.size(); i++) {
    slots.add(findViewById(slotIDs.get(i)));
    // slots.get(i).setPadding(8,0,8,0);
    if (LANGUAGE_ID != 5) {
    if (MainActivity.IS_TABLET)
    slots.get(i).setTextSize(TypedValue.COMPLEX_UNIT_PX, slots.get(i).getTextSize()
    * (MainActivity.IS_TABLET_XL ? COEF_FOR_TABLET_XL : COEF_FOR_TABLET));
    } else {
    slots.get(i).setTextSize(TypedValue.COMPLEX_UNIT_PX, slots.get(i).getTextSize()
    * 1.35f);
    if (MainActivity.IS_TABLET)
    slots.get(i).setTextSize(TypedValue.COMPLEX_UNIT_PX, slots.get(i).getTextSize()
    * (MainActivity.IS_TABLET_XL ? COEF_FOR_TABLET_XL : COEF_FOR_TABLET)
    * 1.1f);

    }

    }

    for (int i = 0; i < draggedItemIDs.size(); i++) {
    draggedItems.add(findViewById(draggedItemIDs.get(i)));
    //Textsize for tablet
    if (LANGUAGE_ID!=5) {
    if (MainActivity.IS_TABLET)
    draggedItems.get(i).setTextSize(TypedValue.COMPLEX_UNIT_PX, draggedItems.get(i).getTextSize()
    * (MainActivity.IS_TABLET_XL ? COEF_FOR_TABLET_XL : COEF_FOR_TABLET));
    } else {
    draggedItems.get(i).setTextSize(TypedValue.COMPLEX_UNIT_PX, draggedItems.get(i).getTextSize()
    * 1.35f);
    if (MainActivity.IS_TABLET)
    draggedItems.get(i).setTextSize(TypedValue.COMPLEX_UNIT_PX, draggedItems.get(i).getTextSize()
    * (MainActivity.IS_TABLET_XL ? COEF_FOR_TABLET_XL : COEF_FOR_TABLET)
    * 1.1f);
    }
    }

    TextView textView = findViewById(R.id.text_with_this_syllable);

    if (!IS_TALE)
    textView.setText(word);
    else
    textView.setVisibility(View.INVISIBLE);


    TextView bigSyllable = findViewById(R.id.big_syllable);
    bigSyllable.setVisibility(View.GONE);

    TextView textTale = findViewById(R.id.tale_text);
    textTale.setVisibility(View.GONE);

    if (!MainActivity.GAME_MODE) {

    if (!IS_TALE)
    bigSyllable.setVisibility(View.VISIBLE);
    else {
    textTale.setVisibility(View.VISIBLE);
    textTale.setText(word);
    }

    String setSyllable = syllables[syllableId].getSyllable();
    bigSyllable.setText(setSyllable);
    bigSyllable.setOnClickListener(v -> {
    makeMPNull();
    if (MainActivity.dictionary.get(setSyllable.toUpperCase(Locale.ROOT)) != null) {
    int sound = MainActivity.dictionary.get(setSyllable.toUpperCase(Locale.ROOT));
    mp = MediaPlayer.create(SyllableDetailActivity.this, sound);
    mp.start();

    }
    });

    for (int i = 0; i < slots.size(); i++) {
    slots.get(i).setVisibility(View.GONE);
    }
    for (int i = 0; i < draggedItems.size(); i++) {
    draggedItems.get(i).setVisibility(View.GONE);
    }
    } else {
    textView.setVisibility(View.GONE);
    buttonNext.setVisibility(View.INVISIBLE);
    buttonPrev.setVisibility(View.INVISIBLE);

    for (int i = 0; i < listOfSyllablesId.size(); i++) {
    stars.add(findViewById(starIDs.get(i)));
    stars.get(i).setVisibility(View.VISIBLE);
    }

    for (int i = 0; i < stars.size(); i++) {

    int starResource = ((IS_TOPIC ? CURRENT_LETTER_TOPIC : CURRENT_LETTER) > letterId
    || (IS_TOPIC ? CURRENT_WORD_TOPIC : CURRENT_WORD) > i) ?
    R.drawable.star_gold_32
        : R.drawable.star_border_gray_32;

    stars.get(i).setImageDrawable(ContextCompat.getDrawable(this, starResource));

    }

    if (letterId != (IS_TOPIC ? CURRENT_LETTER_TOPIC : CURRENT_LETTER)
    || (IS_TOPIC ? CURRENT_WORD_TOPIC : CURRENT_WORD) > countSyllables)
    buttonNext.setVisibility(View.VISIBLE);

    for (int i = 0; i < slots.size(); i++) {
    slots.get(i).setBackgroundColor(getResources().getColor(R.color.grey_light));
    slots.get(i).setTextColor(getResources().getColor(R.color.grey_light));
    }

    syllablesForChoose = syllables[syllableId].getSyllablesForChoose();
    populateDraggedItems(syllablesForChoose);
    for (int i = syllablesForChoose.size(); i < draggedItems.size(); i++) {
    draggedItems.get(i).setVisibility(View.INVISIBLE);
    }

    String[] arrSyllables = word.split("-");
    syllablesForWord.addAll(Arrays.asList(arrSyllables)); //syllablesForWord = List.of("а", "ку", "ла");

    populateSlots(syllablesForWord);
    for (int i = syllablesForWord.size(); i < slots.size(); i++) {
    slots.get(i).setVisibility(View.GONE);
    }

    for (int i = 0; i < syllablesForChoose.size(); i++) {
    areDropped.add(false);
    }

    for (int i = 0; i < syllablesForChoose.size(); i++) {
    draggedItems.get(i).setOnTouchListener(touchListener);

    }

    for (int i = 0; i < syllablesForWord.size(); i++) {
    slots.get(i).setOnDragListener(dragListener);
    }
    }

  }

  private void placeSplitText(String word) {
    SplitText words = new SplitText();
    List<String> splitText = words.getWordList(word);

    linearLayout = findViewById(R.id.llayout);
    Display display = getWindowManager().getDefaultDisplay();
    Point size = new Point();
    display.getRealSize(size);

    int screenWidth = size.x - (linearLayout.getPaddingStart() + linearLayout.getPaddingEnd());

    listOfTextViewElements = new ArrayList<>();

    TextView textViewPattern = findViewById(MainActivity.IS_TABLET ? R.id.txtViewForTablet : R.id.txtView);
    TextView textViewPatternFuture = findViewById(MainActivity.IS_TABLET ? R.id.txtViewForTabletFuture : R.id.txtViewFuture);

    int rowNumber = 0;
    addLinearLayoutInRow(rowNumber);

    int cumulativeWidth;
    String cumulativeString = "";

    int cumulativeWidthFuture;
    String cumulativeStringFuture = splitText.get(0);

    for (int i = 0; i < splitText.size(); i++) {
      listOfTextViewElements.add(new TextView(getApplicationContext()));
      listOfTextViewElements.get(i).setText(splitText.get(i).contains("\n") ? splitText.get(i).substring(1) : splitText.get(i));
      listOfTextViewElements.get(i).setTextSize(TypedValue.COMPLEX_UNIT_PX, textViewPattern.getTextSize());
      listOfTextViewElements.get(i).setFontFeatureSettings(textViewPattern.getFontFeatureSettings());

      cumulativeString += splitText.get(i);
      if (i < splitText.size() - 1)
        cumulativeStringFuture += splitText.get(i + 1);

      textViewPattern.setText(cumulativeString);
      textViewPattern.measure(0, 0);
      cumulativeWidth = textViewPattern.getMeasuredWidth();

      textViewPatternFuture.setText(cumulativeStringFuture);
      textViewPatternFuture.measure(0, 0);
      cumulativeWidthFuture = textViewPatternFuture.getMeasuredWidth();

      if (i < splitText.size() - 1)
        if (cumulativeWidthFuture >= (screenWidth - SAFE_ZONE) && !areLetters(splitText.get(i + 1))
            || cumulativeWidth >= (screenWidth - SAFE_ZONE) && areLetters(splitText.get(i))
            || splitText.get(i).contains("\n")) {

          cumulativeString = splitText.get(i);
          cumulativeStringFuture = splitText.get(i) + splitText.get(i + 1);

          addLinearLayoutInRow(++rowNumber);
        }

      linearLayouts.get(rowNumber).addView(listOfTextViewElements.get(i));

      if (areLetters(splitText.get(i))) {
        listOfTextViewElements.get(i).setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(View view) {
        makeMPNull();
        if (MainActivity.dictionary.get(((TextView) view).getText().toString().toUpperCase(Locale.ROOT)) != null) {
        Handler handler = new Handler(Looper.myLooper());
        handler.postDelayed(new Runnable() {
        @Override
        public void run() {
        ((TextView) view).setBackgroundColor(Color.WHITE);
        }
        }, 500);
        ((TextView) view).setBackgroundColor(Color.CYAN);
        int sound = MainActivity.dictionary.get(((TextView) view).getText().toString().toUpperCase(Locale.ROOT));
        mp = MediaPlayer.create(getBaseContext(), sound);
        mp.start();
        }
        }
        });
      }

    }
  }

  public void makeMPNull() {
    if (mp != null) {
      if (mp.isPlaying())
        mp.stop();
      mp.reset();
      mp.release();
      mp = null;
    }
  }

  @Override
  public void onBackPressed() {
    super.onBackPressed();
  }

  private void goToNextSyllable() {
    boolean isLastCard = (countSyllables + 1) == listOfSyllablesId.size();
    if (MainActivity.GAME_MODE

        && (isDone()
            || (IS_TOPIC ? CURRENT_LETTER_TOPIC : CURRENT_LETTER) > letterId
            || (IS_TOPIC ? CURRENT_WORD_TOPIC : CURRENT_WORD) > countSyllables)

        && !isLastCard

        || !MainActivity.GAME_MODE) {
      for (int i = 0; i < handler.size(); i++) {
        handler.get(i).removeCallbacksAndMessages(null);
      }
      Intent intent = new Intent(SyllableDetailActivity.this, SyllableDetailActivity.class);
      if (countSyllables == listOfSyllablesId.size() - 1)
        intent.putExtra(SYLLABLE_COUNT, 0);
      else
        intent.putExtra(SYLLABLE_COUNT, countSyllables + 1);

      intent.putExtra(EXTRA_SYLLABLES_ID, listOfSyllablesId);
      intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
      SyllableDetailActivity.this.startActivity(intent);
    // Set transition animation to next image
    this.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    } else if ((isDone() || (IS_TOPIC ? CURRENT_LETTER_TOPIC : CURRENT_LETTER) > letterId) && isLastCard) {

    onBackPressed();
    this.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    if (MainActivity.GAME_MODE && (IS_TOPIC ? CURRENT_WORD_TOPIC : CURRENT_WORD) >=/*==*/ listOfSyllablesId.size()) {
    Toast.makeText(SyllableDetailActivity.this, getResources().getString(R.string.make_a_word), Toast.LENGTH_SHORT).show();

    }

  }

  private void gotoPrevSyllable() {
    if (!MainActivity.GAME_MODE) {
      Intent intent = new Intent(SyllableDetailActivity.this, SyllableDetailActivity.class);
      if (countSyllables == 0)
        intent.putExtra(SYLLABLE_COUNT, listOfSyllablesId.size() - 1);
      else
        intent.putExtra(SYLLABLE_COUNT, countSyllables - 1);

      intent.putExtra(EXTRA_SYLLABLES_ID, listOfSyllablesId);
      intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
      SyllableDetailActivity.this.startActivity(intent);
    // Set transition animation to  prev image
    this.overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
  }
  }

  @Override
  protected void onStop() {
    super.onStop();
    makeMPNull();
  }


  @Override
  public boolean onDown(MotionEvent e) {
    return false;
  }

  @Override
  public void onShowPress(MotionEvent e) {
  }

  @Override
  public boolean onSingleTapUp(MotionEvent e) {
    return false;
  }

  @Override
  public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
    return false;
  }

  @Override
  public void onLongPress(MotionEvent e) {
  }

  @Override
  public boolean onFling(MotionEvent downEvent, MotionEvent moveEvent, float velocityX, float velocityY) {
    boolean result = false;
    try {
      float diffY = moveEvent.getY() - downEvent.getY();
      float diffX = moveEvent.getX() - downEvent.getX();

      makeMPNull();

      //which was greater? movement across Y or X?
      if (Math.abs(diffX) > Math.abs(diffY)) {
        // right or left swipe
        if (Math.abs(diffX) > SWIPE_TRESHOLD && Math.abs(velocityX) > SWIPE_VELOCITY_TRESHOLD) {
          if (diffX > 0) {
            // swipe on the right
            onSwipeRight();
            result = true;
          } else {
            // swipe on the left
            onSwipeLeft();
            result = true;
          }
        }
      }
    } catch (Exception e) {

    }
    return result;
  }

  @Override
  public boolean onTouchEvent(MotionEvent event) {

    if (gestureDetector != null)//TODO check if handled
      gestureDetector.onTouchEvent(event);
    return super.onTouchEvent(event);
  }

  private void onSwipeLeft() {
    goToNextSyllable();
  }

  private void onSwipeRight() {
    gotoPrevSyllable();
  }

  public void populateDraggedItems(List<String> syllablesList) {
    for (int i = 0; i < syllablesList.size(); i++) {
      String syllable = syllablesList.get(i);
      if (syllable.length() == 1) {
//                System.out.println(syllable);
        boolean isNarrow = syllable.matches("[ІЇIÎ]");
        draggedItems.get(i).setPadding(isNarrow ? 30 : 20, 0, isNarrow ? 30 : 20, 0);

      }
      draggedItems.get(i).setText(syllablesList.get(i));
    }
  }

  public void populateSlots(List<String> syllablesList) {
    for (int i = 0; i < syllablesList.size(); i++) {
      String syllable = syllablesList.get(i);
      if (syllable.length() == 1) {
        boolean isNarrow = syllable.matches("[ІЇIÎ]");
        slots.get(i).setPadding(isNarrow ? 26 : 18, 0, isNarrow ? 26 : 18, 0);
      }
      slots.get(i).setText(syllablesList.get(i));
    }
  }

  View.OnTouchListener touchListener = new View.OnTouchListener() {

  @Override
  public boolean onTouch(View v, MotionEvent event) {
    try {

      if (event.getAction() == MotionEvent.ACTION_DOWN) {
        int draggedViewNum = 0;
        for (int i = 0; i < draggedItems.size(); i++) {
          if (v.getId() == draggedItemIDs.get(i)) {
            draggedViewNum = i;
          }
        }
        String str = draggedItems.get(draggedViewNum).getText().toString().toUpperCase();

        makeMPNull();
        if (MainActivity.dictionary.get(str) != null) {
          int sound = MainActivity.dictionary.get(str);

          mp = MediaPlayer.create(SyllableDetailActivity.this, sound);
          mp.start();
        }
        ClipData data = ClipData.newPlainText("", "");
        View.DragShadowBuilder myShadowBuilder = new View.DragShadowBuilder(v);
        v.startDrag(data, myShadowBuilder, v, 0);

        return true;
      } else
        return false;
    } catch (Exception e) {
    return false;
    }
  }
};

View.OnDragListener dragListener = new View.OnDragListener() {
//        @SuppressLint("ResourceAsColor")
@Override
public boolean onDrag(View v, DragEvent event) {
  try {
    int dragEvent = event.getAction();
    View view = (View) event.getLocalState();

    int draggedViewNum = 0;
    for (int i = 0; i < draggedItems.size(); i++) {
      if (view.getId() == draggedItemIDs.get(i)) {
        draggedViewNum = i;
      }
    }

    switch (dragEvent) {

    case DragEvent.ACTION_DROP:
    for (int i = 0; i < slots.size(); i++) {
    if (v.getId() == slotIDs.get(i)) {
    int COLOR_OF_VISIBILITY = getResources().getColor(R.color.purple_200);
    if (draggedItems.get(draggedViewNum).getText().toString().equals(slots.get(i).getText().toString())
    && slots.get(i).getCurrentTextColor() != COLOR_OF_VISIBILITY

    && (!SYLLABLES_IN_ORDER || SYLLABLES_IN_ORDER && i == numOfFilledSlots)
    ) {
    //TODO
    numOfFilledSlots++;

    // makeMPNull();

    slots.get(i).setTextColor(COLOR_OF_VISIBILITY);
    areDropped.set(draggedViewNum, true);
//                                    buttonNext.setVisibility(View.INVISIBLE);
    if (!isDone()) {
    makeMPNull();
    mp = MediaPlayer.create(SyllableDetailActivity.this, R.raw.ding);
    mp.start();
    } //TODO ELSE move to here (*) code for sound
    else {
    slots.get(0).setTextColor(Color.parseColor("#ff00cc00"));
    String str = slots.get(0).getText().toString().toUpperCase();

    makeMPNull();
    if (MainActivity.dictionary.get(str) != null) {
    int sound = MainActivity.dictionary.get(str);
    mp = MediaPlayer.create(SyllableDetailActivity.this, sound);
    mp.start();
    }

    for (int j = 0; j < syllablesForWord.size(); j++) {
    int indexj = j;
    handler.get(indexj).postDelayed(() -> {

    if (indexj < syllablesForWord.size() - 1) {
    slots.get(indexj + 1).setTextColor(Color.parseColor("#ff00cc00"));
    makeMPNull();
    String str2 = slots.get(indexj + 1).getText().toString().toUpperCase();

    if (MainActivity.dictionary.get(str2) != null) {
    int sound = MainActivity.dictionary.get(str2);
    mp = MediaPlayer.create(SyllableDetailActivity.this, sound);
    mp.start();
    }
    } else {
    if (syllablesForWord.size() > 1) {
    makeMPNull();
    mp = MediaPlayer.create(SyllableDetailActivity.this, syllables[syllableId].getSoundResourceId());
    mp.start();
    }
    }
    slots.get(indexj).setTextColor(COLOR_OF_VISIBILITY);

    }, 1000L * (1 + indexj));
//                                            slots.get(indexj).setTextColor(Color.parseColor("#00ff00"));
    }
    handler.get(handler.size() - 1).postDelayed(() -> {
    buttonNext.setVisibility(View.VISIBLE);
    }, 1000L * (1 + syllablesForWord.size()));

    }

    if (isDone() && (IS_TOPIC ? CURRENT_LETTER_TOPIC : CURRENT_LETTER) == letterId) {
    if ((IS_TOPIC ? CURRENT_WORD_TOPIC : CURRENT_WORD) <= countSyllables)
    if (IS_TOPIC)
    CURRENT_WORD_TOPIC++;
    else
    CURRENT_WORD++;
    if ((IS_TOPIC ? CURRENT_WORD_TOPIC : CURRENT_WORD) >=/*==*/ listOfSyllablesId.size()) {

    if (IS_TOPIC)
    CURRENT_WORD_TOPIC = 0;
    else
    CURRENT_WORD = 0;
    if (IS_TOPIC)
    CURRENT_LETTER_TOPIC++;
    else
    CURRENT_LETTER++;

    settingsActivity.writeFromIAC(SyllableDetailActivity.this);
    Objects.requireNonNull(AlphabetActivity.adapter).notifyDataSetChanged();

    }

    settingsActivity.writeFromIAC(SyllableDetailActivity.this);
    stars.get(countSyllables).setImageDrawable(ContextCompat.getDrawable(SyllableDetailActivity.this, R.drawable.star_gold_32));

    }
    }
    }
    }
    break;

    case DragEvent.ACTION_DRAG_ENDED:
    if (!areDropped.get(draggedViewNum))
    draggedItems.get(draggedViewNum).setVisibility(View.VISIBLE);
    break;

    case DragEvent.ACTION_DRAG_STARTED:
    draggedItems.get(draggedViewNum).setVisibility(View.INVISIBLE);
    break;
    }
    return true;
  } catch (Exception e) {
  e.printStackTrace();
  return false;
  }
}
};

private boolean previousDone(int i) {
  return i == numOfFilledSlots;
}

private boolean isDone() {
  int count = 0;
  for (int i = 0; i < areDropped.size(); i++)
    if (areDropped.get(i))
      count++;
  return count == syllablesForWord.size();
}

private void addLinearLayoutInRow(int rowNumber) {
  linearLayouts.add(new LinearLayout(this));
  linearLayouts.get(rowNumber).setOrientation(LinearLayout.HORIZONTAL);
  linearLayout.addView(linearLayouts.get(rowNumber));
}
}
*/