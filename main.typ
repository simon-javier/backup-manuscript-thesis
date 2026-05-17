#set text(font: "TeX Gyre Termes", size: 12pt, hyphenate: false, lang: "en")

#let font-size = 12pt
#let double-spacing = 1.5em


#let chp(title, hidden: false) = {
  show heading: none
  heading(level: 1, outlined: false, bookmarked: true)[#title]
  if not hidden {
    align(center)[*#upper(title)*]
  } else {}
}

#let h1(hidden: false, title) = {
  if not hidden {
    heading(level: 1, outlined: true, bookmarked: true)[#title]
  } else {
    show heading: none
    heading(level: 1, outlined: true, bookmarked: true)[#title]
  }
}

#let h2(title, c: true, hidden: false, outlined: true, bookmarked: true, uppercase: true) = {
  show heading: none
  set par(first-line-indent: 0em)
  if not outlined {
    if not bookmarked {
      heading(level: 2, outlined: false, bookmarked: false)[#title]
    } else {
      heading(level: 2, outlined: false, bookmarked: true)[#title]
    }
  } else {
    if not bookmarked {
      heading(level: 2, bookmarked: false)[#title]
    } else {
      heading(level: 2, bookmarked: true)[#title]
    }
  }

  if not hidden {
    if uppercase {
      if not c {
        [*#upper(title)*]
      } else {
        align(center)[*#upper(title)*]
      }
    } else {
      if not c {
        [*#title*]
      } else {
        align(center)[*#title*]
      }
    }
  }
}

#let h3(title, hidden: false) = {
  show heading: none
  set par(first-line-indent: 0em)
  if not hidden {
    heading(level: 3)[#title]
  } else {
    heading(level: 3, outlined: false, bookmarked: true)[#title]
    align(center)[*#title*]
  }
}

#let h4(title, hidden: false) = {
  show heading: none
  set par(first-line-indent: 0em)
  if not hidden {
    heading(level: 4)[#title]
  } else {
    heading(level: 4, outlined: false, bookmarked: true)[#title]
    align(left)[*#title*]
  }
}

#let defaultSpacing(body) = {
  set par(leading: 0.65em, spacing: 1.2em)
  body
}

#let oneHalfSpacing(body) = {
  set par(leading: 1em, spacing: 1em)
  body
}

#let singleSpacing(body) = {
  set par(leading: 0.5em, spacing: 0.5em)
  body
}


#set page(
  margin: (
    y: 1in,
    left: 1.5in,
    right: 1in,
  ),
  header: context {
    let current-page = here().page()
    let page-number = counter(page).display()
    let chapter-page = query(heading.where(level: 1)).filter(it => lower(it.body.text).contains("chapter"))
    let has-chapter = chapter-page.any(it => it.location().page() == current-page)

    let in-prelim-page = query(selector(heading).after(<prelim-s>).before(<prelim-e>)).any(it => (
      it.location().page() == current-page
    ))

    let in-postlude-page = query(selector(here()).after(<post-s>).before(<post-e>)).any(it => (
      it.location().page() == current-page
    ))

    if not has-chapter and not in-postlude-page {
      align(right)[#page-number]
    }
  },
)

#let in-outline = state("in-outline", false)
#show outline: it => {
  in-outline.update(true)
  it
  in-outline.update(false)
}

#let flex-caption(long, short) = context if in-outline.get() { short } else { long }

#set par(
  justify: true,
  first-line-indent: (
    amount: 0.5in,
    all: true,
  ),
  leading: 1.5em,
  spacing: 1.5em,
)

#show heading: set text(size: font-size)
#show heading: set block(spacing: double-spacing)

#show heading: it => emph(strong[#it.body.])
#show heading.where(level: 1): it => align(center, strong(it.body))
#show heading.where(level: 2): it => align(center, strong(it.body))

#show heading.where(level: 3): it => par(first-line-indent: 0in, strong(it.body))

#show heading.where(level: 4): it => par(first-line-indent: 0in, emph[#it.body])

#show heading.where(level: 5): it => strong[#it.body.]
#show heading.where(level: 6): it => emph(strong[#it.body.])



#show figure: set block(breakable: true, sticky: true)
#show figure.where(kind: table): set block(breakable: true, sticky: false)
#show figure.where(kind: table): set figure(placement: none)
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: "equation"): set figure(supplement: "Equation")
#show figure.where(kind: raw): set figure(supplement: "Code Snippet")
#show figure.where(kind: "equation"): it => [
  #show math.equation: set text(size: 16pt)
  #it.body
  #it.caption
]
#set figure(
  gap: double-spacing,
  numbering: "1.",
  placement: none,
)

#set figure.caption(separator: none, position: bottom)

#show outline.entry.where(level: 1): it => link(it.element.location(), it.indented(strong(it.prefix()), it.inner()))

#show figure.caption.where(kind: table): set align(left)
#show figure.caption: set par(first-line-indent: 0em)
#show figure.caption: it => {
  [*#it.supplement #context it.counter.display(it.numbering)#it.separator* #it.body]
}

#set list(
  marker: ([•], [◦]),
  indent: 0.5in - 1.75em,
  body-indent: 1.3em,
)

#set enum(
  indent: 0.5in - 1.5em,
  body-indent: 0.75em,
  numbering: "1.1.1.",
  full: true,
)

#set raw(
  tab-size: 4,
  block: true,
)

#show raw.where(block: true): block.with(
  fill: luma(250),
  stroke: (left: 3pt + rgb("#6272a4")),
  inset: (x: 10pt, y: 8pt),
  width: 100%,
  breakable: true,
  outset: (y: 7pt),
  radius: (left: 0pt, right: 6pt),
)

#show raw: set text(
  size: 10pt,
)


#show raw.where(block: true): set par(leading: 1em)
#show figure.where(kind: raw): set block(breakable: true, sticky: false, width: 100%)

#set math.equation(numbering: "(1)")

#show quote.where(block: true): set block(spacing: double-spacing)

#show quote: it => {
  let quote-text-words = to-string(it.body).split(regex("\\s+")).filter(word => word != "").len()

  if quote-text-words < 40 {
    ["#it.body" ]

    if (type(it.attribution) == label) {
      cite(it.attribution)
    } else if (
      type(it.attribution) == str or type(it.attribution) == content
    ) {
      it.attribution
    }
  } else {
    block(inset: (left: 0.5in))[
      #set par(first-line-indent: 0.5in)
      #it.body
      #if (type(it.attribution) == label) {
        cite(it.attribution)
      } else if (type(it.attribution) == str or type(it.attribution) == content) {
        it.attribution
      }
    ]
  }
}

#set image(width: 80%)

#set bibliography(style: "apa")
#show bibliography: set par(first-line-indent: 0in)

#metadata("group 1 start") <prelim-s>
#set page(numbering: "i", number-align: top + right)
#let title = [Probabilistic Detection of Systemic Diseases Using Deep Learning on Fingernail Biomarkers]

#let title_page = context counter(page).display()
#page(header: none)[#align(center)[
  #{
    show heading: none
    [== Title Page]
  }

  #singleSpacing[*#upper(title)*]
  \
  \
  \
  An Undergraduate Thesis \
  Presented to the \
  Faculty of College of Computer Studies \
  Laguna State Polytechnic University \
  Santa Cruz Campus
  \
  \
  \
  In Partial Fulfillment of the requirements for the Degree \
  *BACHELOR OF SCIENCE IN COMPUTER SCIENCE* \
  *Major in Intelligent System*

  \
  \
  \
  \
  #oneHalfSpacing[
    By: \
    *
      JAVIER, GERON SIMON A. \
      MACAPALLAG, MHAR ANDREI C. \
      VALDEABELLA, SEANREI ETHAN M.
      \
    *
  ]
  \
  \
  Under the supervision of: \
  *MIA V. VILLARICA, DIT*
  #v(1fr)
  #upper[*#datetime.today().display("[MONTH repr:long] [year]")*]
]]
#pagebreak()

#singleSpacing[
  #show heading: none
  #set par(first-line-indent: 0em)
  == Vision, Mission, and Objectives of BSCS Program
  #set enum(spacing: 1.5em, indent: 0em)

  #align(center)[*VISION*]
  \
  The Laguna State Polytechnic University is a center of sustainable development initiatives transforming lives and communities.
  \
  \
  #align(center)[*MISSION*]
  \
  LSPU, driven by progressive leadership, is a premier institution providing technology- mediated agriculture, fisheries, and other related and emerging disciplines significantly contributing to the growth and development of the region and nation.
  \
  \
  #align(center)[*QUALITY POLICY*]
  \
  LSPU delivers quality education through responsive instruction, distinctive research, sustainable extension, and production services. Thus, we are committed with continual improvement to meet applicable requirements to provide quality, efficient and effective services to the university stakeholders’ highest level of satisfaction through an excellent management system imbued with utmost integrity, professionalism and innovation.
  \
  \
  #align(center)[*College of Computer Studies Goal*]
  \
  The College of Computer Studies graduates are expected to become globally competitive and innovative computing professionals imbued with utmost integrity, contributing to the country’s national development goals.
  \
  \
  #align(center)[*Program Educational Objective*]
  \
  The Bachelor of Science in Computer Science (BSCS) graduates are computing professionals and proficient researchers in designing and developing innovative solutions. It is designed to enable students to achieve the following by the time they graduate:
  \
  \
  + Apply knowledge of computing solutions from fundamentals to complex problems appropriate for the abstraction and conceptualization of computing models.
  + Communicate effectively and recognize the legal, ethical and professional issues governing the utilization of computer technology and to engage in independent learning development as a computing professional.
  + Ability to apply design, develop and evaluate systems’ components and processes through mathematical foundations, algorithmic principles and computer science theories.
  + Developed a culture of research for technology advancement.
  + Demonstrated good leadership and a team player that will contribute to nation building and engage in life-long learning as foundation for professional development.

]

#pagebreak()

#singleSpacing[
  #h2[Approval Sheet]

  #set par(first-line-indent: (
    amount: 0.5in,
    all: true,
  ))

  \

  The thesis entitled *"#upper(title)"* prepared and submitted by *GERON SIMON A. JAVIER*, *MHAR ANDREI C. MACAPALLAG*, and *SEANREI ETHAN M. VALDEABELLA* in partial fulfillment of the requirements for the degree of *BACHELOR OF SCIENCE IN COMPUTER SCIENCE*, major in *INTELLIGENT SYSTEMS* is hereby recommended for approval and acceptance.
  \
  \
  \
  #grid(
    columns: (1fr, 1fr, 1fr),
    [], [], align(center)[*MIA V. VILLARICA, DIT* \ Thesis Adviser],
  ) #v(0.5em)

  #line(length: 100%)
  #v(0.5em)

  Approved by the Committee on Oral Examination with a grade of #underline[#box(width: 3em, repeat(sym.space))].
  \
  \
  \
  \
  #grid(
    columns: (1fr, 1fr),
    row-gutter: 4em,
    align: center,
    [*MARK P. BERNARDINO, MSCS* \ Member],
    [*VICTOR A. ESTALILLA JR.* \ Member],
    text(size: 12pt)[*MICAH JOY F. VALDEZ* \ Member],
    text(size: 10pt)[*JHON JHON P. ZOTOMAYOR, LPT, MAED* \ Member],
    grid.cell(colspan: 2)[*MARIA LAUREEN B. MIRANDA, LPT, MIT* \ Research Implementing Unit Head],
  )

  #v(1.5em)#line(length: 100%)#v(0.5em)

  Accepted and approved in partial fulfillment of the requirement for the degree of *BACHELOR OF SCIENCE IN COMPUTER SCIENCE*, Major in *INTELLIGENT SYSTEMS*.
  \
  \
  \
  #grid(
    columns: (1fr, 1fr),
    align: center,
    [], [*MIA V. VILLARICA, DIT* \ Associate Dean, CCS],
  )
  #v(1fr)
  #grid(
    columns: (1fr, 1fr),
    align: center,
    [*ROSARIO G. CATAPANG, PhD, Ffp* \ Chairperson, Research And Development],
    [#underline[#box(width: 10em, repeat(sym.space))]\ Date Signed],
  )
  #v(1fr)

  #table(
    columns: (1fr, 1fr),
    inset: 0.5em,
    [*RESEARCH CONTRIBUTION NO.*], [],
  )
]
#pagebreak()

#singleSpacing[

  #h2[Acknowledgement]
  \

  The researchers would like to express their sincere gratitude to the following individuals who have contributed and supported them in the completion of the study:
  \
  \

  First and foremost, to *OUR ALMIGHTY GOD*, for empowering the researcher when they feel down, gives them strength, patience, spiritual guidance, and everything provided when they need it most;
  \
  \

  To their Thesis Adviser and Associate Dean of the College of Computer Studies, *MS. MIA V. VILLARICA, DIT*, for her time, effort, and patience in checking the papers from time to time, and for sharing her ideas and constructive critiques, which greatly contributed to the success of this study;
  \
  \

  To their System Expert, *MR. MARK P. BERNARDINO, MSCS,* for improving this thesis's technical features. Their careful consideration to detail has significantly increased the paper's overall structure and clarity;
  \
  \

  To their Technical Editor, *MS. MICAH JOY F. VALDEZ*, who thoughtfully corrected the manuscript's format and content;
  \
  \

  To their Statistician, *MR. VICTOR A. ESTALILLA JR.*, for his guidance on the structure of the data sample and her help in completing the data sampling for the study;
  \
  \

  To their Language Critic, *MR. JHON JHON P. ZOTOMAYOR, LPT, MAED*, for being helpful in checking and revising the manuscript's grammar and its structure;
  \
  \

  To their *FRIENDS* and *CLASSMATES*, for encouraging, helping and inspiring them to finish this study;
  \
  \

  The researchers are deeply thankful to their *FAMILY*, for their unwavering support, love, and care;
  \
  \

  And lastly, they are thankful for the effort and hard work of each member of this *RESEARCH TEAM*, for believing in themselves, for doing all the hard work, and for never quitting in order to make this humble work a success.

  #pagebreak()
]

#singleSpacing[
  #h2[Abstract]
  \

  Fingernails act as accessible biomarkers for systemic health, often revealing early signs of conditions such as cardiovascular disease and diabetes through subtle architectural changes. However, these indicators are frequently overlooked in standard diagnoses, and existing AI solutions often stop at classification without inferring underlying risks. This study aimed to develop a deep learning-based system that classifies nail features and utilizes Bayesian inference to calculate the probabilistic likelihood of systemic diseases. The researchers utilized a labeled dataset of 7,258 fingernail images across 10 distinct classes (e.g., Clubbing, Koilonychia, Terry’s Nails), verified by a dermatologist. To bridge visual recognition with clinical diagnosis, a statistical dataset was curated from peer-reviewed literature to map nail features to systemic diseases using conditional probabilities. Five deep learning architectures—VGG-16, ResNet-50, EfficientNetV2-S, SwinV2-T, and ConvNeXt-Tiny—were trained using various transfer learning strategies, including full fine-tuning and gradual unfreezing. Performance evaluation demonstrated that modern architectures utilizing a Gradual Unfreezing strategy yielded the best results. ConvNeXt-Tiny achieved the highest accuracy at 88.93%, followed closely by the vision transformer SwinV2-T at 88.27%, significantly outperforming the VGG-16 baseline of 74.92%. The study successfully deployed these models into a web-based prototype that integrates user demographics (age and sex) with Bayesian inference to output ranked probabilities of systemic conditions, providing an interpretable and non-invasive health screening tool. The findings conclude that combining deep learning with probabilistic modeling enhances diagnostic utility by filtering implausible conditions and providing scientifically grounded risk assessments.
  \
  \
  \
  _*Keywords:* Deep Learning, Bayesian Inference, Fingernail Biomarkers, Systemic Diseases, Vision Transformers (ViT), Convolutional Neural Network (CNN), Preventive Healthcare_
]

#pagebreak()


#h2[Definition of Terms]
This section provides a glossary of key terms used throughout the study, divided into technical and operational definitions, to ensure clarity and a comprehensive understanding of the research on #lower(title).

#heading(level: 3, outlined: false)[Technical Terms]
Some terminologies used in the design and development of the developed system were defined in this section.
#grid(
  columns: (1fr, 2fr),
  inset: 1em,

  [*Accuracy*],
  [Accuracy measures how well a CNN model performs. Models hit different rates depending on architecture and training.],

  [*Artificial Intelligence (AI)*],
  [AI has pushed healthcare forward in real ways — better image processing, stronger probabilistic modeling. Diagnostic systems built on AI could speed up disease diagnosis and make it more reliable, at least in principle.],

  [*Bayesian Inference*],
  [Bayesian Inference is a probabilistic model the study uses, alongside Naïve Bayes, for inferring systemic disease probabilities. It runs through the knowledge integration module.],

  [*Batch Learning / Mini Batches*],
  [Training ran on mini batches of 32 images per iteration. That balanced generalization against convergence speed without dragging out the process.],

  [*Convolutional Neural Networks (CNNs)*],
  [CNNs handle the image analysis in this study. They build up spatial feature hierarchies on their own — no manual extraction needed — and that is what makes them good at classifying nail abnormalities. Patterns that a human observer might overlook, CNNs tend to catch.],

  [*ConvNeXt-Tiny*],
  [ConvNeXt-Tiny came in as a replacement for RegNetY-16GF. It has around 28 million parameters and offered a better balance between accuracy and computational cost. With Gradual Unfreezing it hit 88.93% accuracy, the highest of any model tested. For classifying the subtle, varied features in fingernail images, nothing else in the study came close.],

  [*Cross Entropy Loss*],
  [Cross Entropy Loss is the loss function used during training, suited to multiclass classification.],

  [*Deep Learning (DL)*],
  [Deep Learning sits inside machine learning and works through deep neural networks that learn layered representations. The study applies it end-to-end — raw images go in, disease classifications come out. No manual feature engineering.],

  [*EfficientNetV2*],
  [EfficientNetV2 S is a pre-trained CNN the study tested. Fewer parameters, faster training, and it still performed well. A good fit for lightweight deployments where diagnostic accuracy still matters.],

  [*F1 Score*],
  [F1 Score is a standard evaluation metric for CNN models. The study also uses it to check per-class performance and figure out where misclassifications cluster.],

  [*Grad CAM*],
  [Grad CAM visualizes which parts of an image drove a model's prediction. The study may explore it to make model reasoning more transparent.],

  [*Image Augmentation*],
  [Augmentation techniques — horizontal flipping, rotation, brightness adjustment — create multiple versions of each source image. More diversity in the dataset, less overfitting.],

  [*Image Classification*],
  [Classifying images into disease categories is the core task. Those category outputs then feed into probabilistic inference, which estimates systemic conditions from the nail-level diagnosis.],

  [*Image Preprocessing*],
  [Before training, images go through preprocessing: resizing, format conversion, augmentation, normalization. All of it keeps inputs consistent and compatible with whatever architecture gets used.],

  [*Image Processing*],
  [Image processing has moved forward a lot with AI. This study puts it to work analyzing fingernail biomarkers through deep learning to detect systemic diseases. The whole approach is built around it.],

  [*Machine Learning (ML)*],
  [Machine Learning is the broader field deep learning belongs to. Support Vector Machines, CNNs, and other techniques have all been applied to improve nail classification. The study draws on that body of work.],

  [*Normalization (Image)*],
  [Images were normalized to ImageNet mean and standard deviation values. That ensures compatibility with pre-trained models, which in turn makes transfer learning work better and keeps gradients stable during training.],

  [*Precision*], [Precision is a standard metric used to evaluate CNN models.],

  [*Probabilistic Modeling / Probabilistic Inference*],
  [Probabilistic modeling pairs deep learning classification with probabilistic inference. Together they estimate systemic disease likelihood and give users risk assessments they can actually use.],

  [*Recall*], [Recall is a standard metric used to evaluate CNN models.],

  [*ResNet*],
  [ResNet was considered for the system. Residual connections give it a reliable baseline. Fine-tuned versions have beaten dermatologists at diagnosing onychomycosis, which says something.],

  [*Sensitivity*], [Sensitivity evaluates probabilistic model performance.],

  [*Specificity*], [Specificity evaluates probabilistic model performance.],

  [*SwinV2-T*],
  [Out of five architectures, SwinV2-T scored highest on every metric — accuracy, precision, recall, F1 score. Computationally heavy, but it is built into the business logic layer for running diagnoses.],

  [*Transfer Learning*],
  [Transfer learning takes models like EfficientNetV2 and ConvNeXt-Tiny that were pre-trained on large datasets and fine-tunes them on nail disease images. Training goes faster, results improve. Normalization keeps inputs consistent enough for this to hold up.],

  [*VGG16*],
  [VGG16 is older. The study benchmarked it and it came in last — lowest accuracy, lowest F1 score, most parameters. Not efficient for fine-grained classification next to newer architectures. A hybrid VGG16–Random Forest setup did hit 97.02% accuracy, though.],

  [*Vision Transformers (ViTs)*],
  [The study explores Vision Transformers alongside CNNs. Their attention-based representations capture long-range dependencies, which could help on harder classification problems. One ViT model was picked for the final build.],

  [*Weighted Loss Function*],
  [Weighted loss functions deal with class imbalance. Each class gets a weight inversely proportional to how often it shows up, so rare classes push the loss harder during training. Without this, the model leans toward whatever class has the most samples.],
)

#heading(level: 3, outlined: false)[Operational Terms]
This section defines any terms or phrases derived from the study operationally, implying the way they were used in the study.

#grid(
  columns: (1fr, 2fr),
  inset: 1em,

  [*Beau's Lines*],
  [Beau's Lines are transverse grooves or depressions that run across the nail plate. They show up when nail growth temporarily slows down — usually from severe systemic illness, trauma, or drug use. Conditions like Raynaud's disease, diabetes, and zinc deficiency can cause them. They have also been linked to COVID-19.],

  [*Biomarkers (Fingernail)*],
  [Fingernails are often called a "window to systemic health," and for good reason. Subtle changes in how they look can reveal early signs of serious conditions. The study treats them as a globally recognized source of biomarkers and focuses on using those signals for probabilistic detection of systemic diseases.],

  [*Blue Finger / Cyanosis*],
  [Blue Finger, or Cyanosis, shows up as acute bluish discoloration of the fingers, sometimes with pain. It means organs, muscles, and tissues are not getting enough blood or oxygen. Lower oxygen saturation causes deoxyhemoglobin to build up, which is what produces the color change.],

  [*Clubbing (Hippocratic Nails)*],
  [Clubbing — also called Hippocratic Nails — is a nail abnormality where the fingers take on a "drum stick" shape and the nails curve like "watch glasses." The nail plate curvature becomes more pronounced. It is considered an important early clinical sign, mostly tied to cardiopulmonary problems.],

  [*Fingernail Disease / Nail Disorders*],
  [Fingernail diseases affect millions of people worldwide. Some of them point to internal systemic conditions. The study classifies these diseases and uses probabilistic inference to connect them back to broader health issues.],

  [*Healthy Nail*], [Healthy nails tend to be smooth and consistent in color. They usually signal good health.],

  [*Koilonychia*],
  [Koilonychia is a nail abnormality that makes dermatological exams more accurate and can alert clinicians to broader health issues. Some models have a harder time classifying it, though.],

  [*Muehrcke's Lines*],
  [Muehrcke's Lines is the most underrepresented class in the dataset. Even so, some models show strong recall for it — which matters in a preventive diagnostic setting.],

  [*Nail Feature*],
  [A nail feature is any distinct visual or morphological characteristic of the fingernail — color, texture, shape, thickness, ridges, lines, discoloration. The deep learning model analyzes these as biomarkers to classify nail diseases, which can point to underlying systemic health conditions.],

  [*Onychomycosis*],
  [Onychomycosis is a common nail condition. Region-based CNNs and deep learning approaches have outperformed dermatologists in diagnosing it.],

  [*Onychogryphosis*],
  [Onychogryphosis is a nail disease involving architectural changes in the nail. Those changes carry important diagnostic information.],

  [*Pitting*],
  [Pitting shows up as small depressions in the nail, usually associated with psoriasis or other systemic diseases. These architectural changes can signal systemic issues. Some models got better at classifying it over time.],

  [*Preventive Healthcare*],
  [Preventive healthcare is what the study is ultimately about. The goal is a non-invasive, accessible tool that lets people screen for health issues early and get actionable recommendations — available to anyone, anywhere.],

  [*Systemic Diseases*],
  [Systemic diseases — diabetes, cardiovascular disorders, liver conditions — often show up early through fingernail abnormalities. That creates a window for intervention. The study uses deep learning on fingernail biomarkers to estimate the probability of these conditions.],

  [*Terry's Nails*],
  [Terry's Nails present as white opacification of the nail with the lunula effaced and distal sparing. Hepatic cirrhosis is the most common association, but congestive heart failure, chronic kidney disease, diabetes mellitus, and even normal aging can produce them too.],
)

#pagebreak()


#let toc = [
  #h2[Table of Contents]
  #h2(c: false)[Preliminaries]
  #outline(target: selector(heading).after(<prelim-s>).before(<prelim-e>), title: none)

  #h2(c: false, outlined: false, bookmarked: false)[#link(<ch1-s>)[CHAPTER I INTRODUCTION AND ITS BACKGROUND]]
  #outline(target: selector(heading).after(<ch1-s>).before(<ch1-e>), title: none)

  #h2(c: false, outlined: false, bookmarked: false)[#link(<ch2-s>)[CHAPTER II REVIEW OF RELATED LITERATURE]]
  #outline(target: selector(heading).after(<ch2-s>).before(<ch2-e>), title: none)

  #h2(c: false, outlined: false, bookmarked: false)[#link(<ch3-s>)[CHAPTER III RESEARCH METHODOLOGY]]
  #outline(target: selector(heading).after(<ch3-s>).before(<ch3-e>), title: none)

  #h2(c: false, outlined: false, bookmarked: false)[#link(<ch4-s>)[CHAPTER IV RESULTS AND DISCUSSION]]
  #outline(target: selector(heading).after(<ch4-s>).before(<ch4-e>), title: none)

  #h2(c: false, outlined: false, bookmarked: false)[#link(<ch5-s>)[CHAPTER V SUMMARY, CONCLUSIONS AND RECOMMENDATIONS]]
  #outline(target: selector(heading).after(<ch5-s>).before(<ch5-e>), title: none)

  #outline(target: selector(heading).after(<post-s>).before(<post-e>), title: none, indent: 0em)

  #pagebreak()

  #h2[List of Figures]
  #outline(target: figure.where(kind: image), title: none)
  #pagebreak()

  #h2[List of Tables]
  #outline(target: figure.where(kind: table), title: none)

  #pagebreak()
  #h2[List of Equations]
  #outline(target: figure.where(kind: "equation"), title: none)

  #pagebreak()
  #h2[List of Code Snippets]
  #outline(target: figure.where(kind: raw), title: none)

  #metadata("group 1 end") <prelim-e>
]

#toc


#pagebreak()

#show table.cell: set par(leading: 1em)
#show table.cell.where(y: 0): strong
#show table.cell.where(y: 0): upper
#show table.cell.where(y: 0): set par(justify: false)
#set table.cell(inset: .5em)
#show table.cell: set text(hyphenate: true)
#show table.cell.where(y: 0): set text(hyphenate: false)

#set table(
  align: (_, y) => if y == 0 { center + horizon } else { left + horizon },
  stroke: (_, y) => (
    left: { 0pt },
    right: { 0pt },
    top: if y < 1 { stroke(2pt) } else if y == 1 { none } else { 0pt },
    bottom: if y < 1 { stroke(1pt) } else { stroke(2pt) },
  ),
)

#set page(numbering: "1")
#counter(page).update(1)

#show heading.where(level: 1): it => align(center, strong(block(it.body)))
#show heading.where(level: 2): it => align(center, strong(block(it.body)))

#show heading.where(level: 3): it => block(it.body)

#show heading.where(level: 4): it => block(emph(it.body))

#show heading.where(level: 5): it => strong[#it.body.]
#show heading.where(level: 6): it => emph(strong[#it.body.])

#let table-multi-page(..table-args) = context {
  let columns = table-args.named().at("columns", default: 1)
  let column-amount = if type(columns) == int {
    columns
  } else if type(columns) == array {
    columns.len()
  } else {
    1
  }

  let table-counter = counter("table")
  table-counter.step()

  // Counter for the amount of pages in the table
  let table-part-counter = counter("table-part" + str(table-counter.get().first()))

  show <table-header>: header => {
    table-part-counter.step()
    context if (table-part-counter.get().first() != 1) {
      text(size: 12pt)[*Table #table-counter.display().* (continued)]
    }
  }

  grid(
    inset: 0mm,
    row-gutter: 2mm,
    grid.header(grid.cell(align(left + bottom)[ #none <table-header> ])),
    ..table-args,
  )
}

#show table: it => table-multi-page(it)
#show figure.where(kind: table): set figure(gap: 1em)

#metadata("Chapter 1 start") <ch1-s>
#set cite(form: "prose")
#chp[Chapter I]
#h2(outlined: false, bookmarked: false)[Introduction and Its Background]
Fingernails have long been called a "window to systemic health" #cite(<singal_nail_2015>, form: "normal"). Changes in how they look can point to serious conditions — diabetes, heart disease, liver problems. Beau's lines are horizontal ridges that show up during stress or illness. Clubbing is when the fingertips get enlarged because of heart or lung issues. Pitting, the small depressions tied to psoriasis or other systemic diseases, is another one. These signs often appear before other symptoms do, but general practitioners tend to miss them. The signs are subtle, and most doctors just do not have the specialized tools and training to catch them during a routine checkup. That delay matters. It matters especially for people in underserved communities who already have limited access to better diagnostics.

Non-invasive diagnostic methods give people a way to keep tabs on their own health and get medical advice before things get worse. A lot of individuals worldwide still face barriers to these services, though, geographical isolation, financial constraints, and a general lack of awareness about what nail changes can actually mean. #cite(<gaurav_artificial_2025>, form: "prose") notes that fingernails are a widely recognized source of biomarkers since they are easy to see and examine. Their role in preventive healthcare has not been explored enough despite that. Making early disease detection accessible on a wider scale and bridging these barriers calls for new kinds of solutions.

Artificial Intelligence has become a major tool for tackling healthcare problems, especially through image processing and probabilistic modeling. Deep learning methods like Convolutional Neural Networks (CNNs) are good at picking up patterns in visual data that humans might not notice. A hybrid Capsule CNN reached 99.40% training accuracy classifying nail disorders #cite(<shandilya_autonomous_2024>, form: "normal"). A region-based CNN also outperformed dermatologists at diagnosing onychomycosis, a common nail condition #cite(<han_deep_2018>, form: "normal"). The problem is these studies usually stop at classifying the nail condition itself. They do not connect it to underlying systemic diseases, and that limits how useful they are for preventive care.

In the Philippines, the Bionyx project was an early attempt at AI-driven nail analysis. It used Microsoft Azure Custom Vision to spot systemic issues — heart, lung, and liver problems — from nail images #cite(<chua_student-made_2018>, form: "normal"). It was a step forward, but the older technology it relied on gave it limited precision compared to what modern deep learning can do now. Other studies internationally have looked at the diagnostic value of nails using machine learning methods like Support Vector Machines and CNNs for better classification accuracy #cite(<dhanashree_fingernail_2022>, form: "normal"). A system that brings together deep learning classification with probabilistic inference to actually estimate how likely someone is to have a systemic disease — and give users something they can act on — is still missing, though.

This study set out to build a deep learning-based system that uses CNN models — EfficientNetV2-S, VGG-16, ResNet-50 and RegNetY-16GF — to classify nail disorders. A vision transformer model, SwinV2-T, was also used for classification, along with probabilistic models /(e.g., Naïve Bayes, Bayesian Inference)/ to infer systemic disease probabilities. The system draws on publicly available datasets from Roboflow. The goal is a tool that is non-invasive and accessible to anyone regardless of where they live or their financial situation, providing probabilistic risk assessments and recommendations so users can seek medical consultation based on their results.

#pagebreak()
=== Research Problem

Systemic diseases, diabetes, cardiovascular disorders, liver conditions,  often show up early through fingernail abnormalities, opening a window for intervention before more severe symptoms develop. Discoloration, texture changes, structural deformities. These signs are subtle and need specialized knowledge to read properly, so they get overlooked during standard medical evaluations a lot of the time. When detection gets delayed, health outcomes get worse. That is especially true in areas with limited access to advanced diagnostics, where catching things early could save lives.

AI-driven technologies have shown promise in tackling this problem by making it possible to classify fingernail disorders accurately. A 2016 study managed 65% accuracy detecting diseases based on nail color analysis, but it was limited because it ignored texture and shape features entirely #cite(<indi_early_2016>, form: "normal"). More recent work using advanced CNN models has pushed nail disorder classification accuracy much higher — up to 99.40% in some cases — but these studies tend to stop at identifying the nail condition #cite(<shandilya_autonomous_2024>, form: "normal"). They do not link the condition to systemic diseases. That gap is what reduces the clinical usefulness of these systems, since they fail to give the kind of comprehensive insights that could actually guide someone toward the right medical action.

AI's potential goes beyond healthcare too. In education, AI tools help create personalized learning experiences. In social services, they bring accessible resources to underserved populations. In healthcare specifically, they can boost diagnostic accuracy — CNNs have outperformed dermatologists when diagnosing nail conditions #cite(<han_deep_2018>, form: "normal"). A system combining deep learning with probabilistic inference could do something similar for preventive healthcare, offering non-invasive screening to people worldwide, especially those without access to specialized medical services. Most existing approaches, though, cannot handle diagnostic uncertainty well or give interpretable results, and that limits how effective they are in practice.

Medical diagnostics has long been after non-invasive methods for better early detection, and fingernails have come up as a promising biomarker because they are so easy to access and examine. #cite(<pinoliad_onyxray_2020>, form: "prose") showed that machine learning for nail-based disease detection is feasible in the Philippines, but their system did not include probabilistic inference for systemic diseases. What is needed is a more integrated approach — one that classifies nail disorders and also estimates how likely an underlying condition is, giving users health insights they can actually do something with.

// Existing research only focuses on classifying nails without linking to systemic diseases
// Existing research using deep-learning on nails lack explainability.
// Existing research lack integration of the model for public use.

Thus, this study specifically seeks to address the following problems:

// How can the use of nails estimate the probability of getting certain diseases?
// How can the researchers gather dataset of atleast 3000 nail images with diverse classes and how can they prepare, preprocess, and etc.
// How can the researchers ensure the model is reliable and accurate
// How can the researcers implement explainability methods for deep learning models
// How can the researchers pick the best models suitable for certain situations?
//

// Specific problem reference

+ How can a diverse dataset of at least 3,000 fingernail images across multiple classes be gathered, prepared, preprocessed, and curated so that it works with deep learning frameworks while also dealing with class imbalance and data quality issues?
+ How can researchers go about systematically collecting and curating statistical data on systemic diseases linked to nail features into a usable dataset, and how can Bayesian inference be applied to that dataset for systemic disease inference?
+ How can the deep learning model's reliability and accuracy be ensured through rigorous training, evaluation, and comparison against benchmarks from existing studies?
+ How can explainability methods — things like Grad-CAM or attention-based visualizations — be built into deep learning models for fingernail analysis so that the results are interpretable and explainable?
+ Which deep learning model performs best for nail feature classification, and how do standard evaluation metrics like accuracy, precision, recall, and F1-score factor into picking the optimal model?
+ How can the best-performing model be put into a prototype application that provides interpretable systemic disease inference from fingernail images, and what are the main challenges in making it suitable for clinical decision support or health screening?


=== Research Objectives
The main objective of the study is to design, develop  and evaluate a deep learning-based system for the classification of nail features that achieves at least 80% accuracy by December, and integrating Bayesian inference for the detection of the probabilities of systemic diseases, providing a non-invasive, accessible, and cost-effective tool to enhance preventive healthcare for individuals globally.

Specifically, this study seeks to achieve the following objectives:
+ To obtain a publicly available fingernail image dataset from Roboflow, consisting of at least 3,000 labeled images across a minimum of 5 distinct nail feature classes, with each image meeting a minimum resolution of 224×224 pixels, the dataset will be verified by a dermatologist. In parallel, to curate a statistical dataset to be used for inference using Bayesian inference, containing percentage-based associations between these nail feature classes and systemic diseases derived from published clinical, epidemiological studies, and literature.
+ To apply standardized preprocessing steps including resizing and normalization to ensure consistency and suitability for deep learning, and to augment the image dataset by at least 30% using systematic geometric and photometric transformations to enhance model generalization and robustness for systemic disease classification.
+ To experiment, develop and train multiple deep learning models (EfficientNetV2S, VGG16, ResNet50, RegNetY-16GF, and SwinV2-T) on the dataset to accurately classify nail features and to make systemic diseases inferences using Bayesian inference from the statistical dataset of systemic diseases.
+ To evaluate and compare the performance of the trained models using standard metrics, including accuracy, precision, recall, and F1-score for convolutional neural networks (CNNs) and apply explainability and interpretability methods for the algorithms.
+ To deploy the models in a prototype application that provides interpretable systemic disease predictions from fingernail images, designed for potential use in clinical decision support or health screening applications.

=== Research Framework
This section lays out the theoretical and conceptual frameworks behind the study, the structure used to develop the proposed system.

==== Theoretical Framework
A theoretical framework is a structure of concepts, definitions, and propositions. It guides how a study is carried out, explaining or predicting the phenomena being studied and the relationships between them. #cite(<vinz_what_2022>) describes it as a foundational review of existing theories — a guiding structure, essentially, for building arguments within a researcher's own work. What the research is built on, in other words. That grounding in established theory is what gives a paper its relevance and shows the work isn't starting from nothing. It justifies the study, gives it context,  and for most research papers, it's where things have to start.

The diagram below brings together deep learning and probabilistic modeling into a detection system for fingernail-based disease analysis, drawing from AI-driven diagnostic methods.

#figure(
  image("./img/ANN-architecture.png"),
  caption: flex-caption(
    [
      Artificial neural network architectures with feed-forward and backpropagation algorithm #cite(<jentzen_mathematical_2025>, form: "normal")],
    [Artificial neural network architectures with feed-forward and backpropagation algorithm],
  ),
) <ann-architecture>

@ann-architecture shows the architecture of an artificial neural network (ANN) from #cite(<jentzen_mathematical_2025>), a book titled "Mathematical Introduction to Deep Learning: Methods, Implementations, and Theory." An ANN, as #cite(<jentzen_mathematical_2025>) describes it, is organized into layers. First is the input layer, where raw data enters the network. Between that and the output sit the hidden layers, these handle the bulk of computation. The output layer comes last. It produces the final result.

Each layer relies on affine functions that take linear transformation matrices (weight matrices) and translation vectors (bias vectors) as trainable parameters. Nonlinear activation functions follow these affine operations, and they are what let the network capture complex patterns in the data. ReLU, GELU, the standard logistic function (sigmoid), hyperbolic tangent (tanh), softplus, swish, clipping, softsign, leaky ReLU, ELU, rectified power unit (RePU), sine, and Heaviside are all examples. The activation function choice matters a lot in practice.

ANNs were chosen as the primary method here because they can learn patterns directly from data. A Convolutional Neural Network (CNN), one specific type, analyzes fingernail images to detect visual features — color, shape, texture — that serve as fingernail biomarkers potentially linked to systemic diseases. After the CNN picks out these biomarkers, Bayesian inference estimates the probability that a person has a given condition. So the system might output something like "there is an 85% chance of anemia." And that kind of probabilistic output is what makes it practical for early detection and preventive healthcare.

#figure(
  image("./img/cnn-architecture.png"),
  caption: flex-caption(
    [Visual representation of a Convolutional Neural Network (CNN) architecture #cite(<zhou_classification_2017>, form: "normal").],
    [Visual representation of a Convolutional Neural Network (CNN) architecture.],
  ),
) <cnn-architecture>

@cnn-architecture shows the architecture of CNN from the study of #cite(<zhou_classification_2017>). A Deep Convolutional Neural Network (CNN), as #cite(<zhou_classification_2017>) explains, is a type of Deep Neural Network (DNN) built to take advantage of how images are structured — pixels near each other tend to be related. That local connectivity is what gives CNNs an edge with large images. A regular DNN connects every node in one layer to every node in the next, which means a huge number of parameters. CNNs cut that down. Each node only connects to a small neighborhood in the previous layer, a region called the receptive field. Nodes in a convolutional layer use different kernels but share the same weights when computing activations. LeNet-5 is a good example of this kind of structure — it has convolutional layers and pooling layers as its core components, then flatten and fully connected layers borrowed from conventional DNNs.

The researchers went with CNNs because of how well they handle image processing. #cite(<zhou_classification_2017>) points out that CNNs focus on small local areas instead of linking every node to every other node, and that is what makes them more efficient at picking up important features in large images. For this research, CNNs were used to detect nail biomarkers from fingernail images — things like shapes, textures, color differences. And their ability to capture those local visual details through convolutional and pooling layers made them a solid choice for comparing models in nail image analysis.

#figure(image("./img/transformer-architecture.png"), caption: flex-caption(
  [
    Vision Transformer (ViT) Architecture for Image Classification #cite(<dosovitskiy_image_2020>, form: "normal").],
  [Vision Transformer (ViT) Architecture for Image Classification.],
)) <transformer-architecture>


@transformer-architecture shows the architecture of ViT from the study of #cite(<dosovitskiy_image_2020>). The Vision Transformer (ViT), as they describe it, takes the standard Transformer — originally built for Natural Language Processing — and repurposes it for image recognition. How it works is straightforward, at least in concept. The input image gets split into fixed-size, non-overlapping 2D patches. Those patches are flattened and then mapped to a constant latent dimension through a trainable linear projection, producing what are called "patch embeddings." Learnable 1D position embeddings get added on top to preserve spatial information. There is also a learnable "classification token," similar to BERT's `[class]` token, prepended to the sequence — its output state from the Transformer encoder is what represents the whole image for classification. The full sequence of vectors then passes through a standard Transformer encoder: alternating layers of multi-headed self-attention (MSA) and MLP blocks, with Layer Normalization before each block and residual connections after. A classification head sits at the end — an MLP during pre-training, a single linear layer during fine-tuning. And unlike CNNs, this whole design has very few image-specific inductive biases baked in.

The researchers used ViT because it offers a fundamentally different approach to analyzing images. Instead of relying on built-in assumptions about spatial structure the way CNNs do, ViT treats images as sequences of patches, much like how words are handled in text processing. #cite(<dosovitskiy_image_2020>) makes the case that this lets the model attend to different parts of an image and pick up on visual patterns more flexibly. For fingernail images specifically, that flexibility matters — subtle color shifts or texture changes that serve as nail biomarkers might be missed by traditional CNNs. But ViT can, at least in theory, capture those fine details more effectively. The researchers wanted to test whether this newer method could outperform CNNs at detecting features that are easy to overlook.

#[
  #grid(
    columns: 1fr,
    row-gutter: 1em,
    [#figure(
      kind: "equation",
      [
        $P(A|B)=P(A inter B)/P(B) = (P(A) dot P(B|A))/P(B)$
      ],
      caption: flex-caption(
        [Formula of Bayes' Theorem #cite(<hayes_bayes_2025>, form: "normal")],
        [Formula of Bayes' Theorem],
      ),
    ) <bayes-formula>],
    [*where:*],
    [$P(A)=$ The probability of A occuring],
    [$P(B)=$ The probability of B occuring],
    [$P(A|B)=$ The probability of A given B],
    [$P(B|A)=$ The probability of B given A],
    [$P(A inter B)=$ The probability of both A and B occuring],
  )
]

The study uses Bayes' theorem for inference, as shown in @bayes-formula. @hayes_bayes_2025 describes it as a formula for working out conditional probability — basically, how likely something is to happen given that something else already happened in similar circumstances. What makes it useful is that it lets you revise a prediction or theory as new evidence shows up.

@rao_medical_2023 makes the point that clinical decision-making already follows Bayesian thinking, whether doctors realize it or not. The theorem works well for diseases that affect multiple parts of the body. Its main advantage is letting a doctor update an initial guess — the prior probability — as more evidence comes in. Diagnosis in medicine usually starts broad, with a list of possible conditions, and gets narrower as test results, observations, and prevalence data accumulate. That step-by-step narrowing is Bayesian inference in practice.

Probabilities matter in clinical predictions. A single fixed prediction can create a false sense of certainty, and it is not much help when a case is unclear or borderline. A full probability distribution over possible diseases, on the other hand, gives much more to work with #cite(<chen_probabilistic_2021>, form: "normal"). The doctor sees not just the most likely diagnosis but how probable the alternatives are too. That directly supports differential diagnosis, where multiple conditions stay on the table #cite(<semigran_comparison_2016>, form: "normal"). Decision thresholds are another benefit. An aggressive disease might warrant action even at low probability — better to catch it early than miss it. But for something less serious, a doctor might wait for a higher probability before ordering more tests, partly to limit unnecessary procedures and partly to reduce patient anxiety. Decision curve analysis captures this trade-off by measuring the net benefit of different probability thresholds #cite(<vickers_decision_2006>, form: "normal").

Personalized risk assessment is where the Bayesian framework really shows its value, and it ties into what precision medicine is trying to do. The prior probability, $P(A)$, does not have to be the same for every patient. It can reflect patient-specific details — age, sex, genetics, existing health conditions. Once that information is folded in, the model produces a probability tailored to that individual. So instead of acting as a general classifier, the system becomes something that brings together different types of patient data in a principled way. The result is a more complete assessment, and a more clinically useful one #cite(<chatzimichail_software_2024>, form: "normal").

#figure(
  kind: "equation",
  [
    $P("Disease"|"Feature")=(P("Disease") dot P("Feature"|"Disease"))/P("Feature")$
  ],
  caption: [Representation of Bayes’ Theorem for calculating the conditional probability of disease occurrence based on observed features],
)<bayes-application>

@bayes-application shows how the probability of having a systemic disease gets updated once a certain nail feature is observed. The researchers use Bayes' Theorem here to link nail features to disease probabilities. On the left side, $P("Disease"|"Feature")$ is what they are trying to find, the probability that a person actually has the disease given that the feature is present. The numerator breaks into two parts. $P("Feature"|"Disease")$ captures how likely the feature is to show up if the disease exists. $P("Disease")$ is the prior, how common the disease is in the general population. Multiply those together and you get the joint probability of both the disease and the feature occurring at the same time. The denominator, $P("Feature")$, is just the overall chance of seeing that feature in the population regardless of disease status. It acts as a normalizing factor — without it, the result would not be a proper probability. What this approach does, in practice, is combine two things: how strongly a feature relates to a disease and how often both show up in the population. And that combination produces a more accurate probability than either piece alone. The updated value is what helps determine whether a nail feature is actually a dependable indicator of disease, or just a coincidence.

#figure(
  image("./img/shandilya-theoretical.jpg", width: 100%),
  caption: flex-caption(
    [End-to-end framework for nail image classification using deep learning models. #cite(<shandilya_autonomous_2024>, form: "normal")],
    [End-to-end framework for nail image classification using deep learning models.],
  ),
) <theo-shandilya>

@theo-shandilya describes the framework used for nail disease classification. Data gathering comes first — collecting images of nails with different conditions to build a dataset for training and testing. The Nail Disease Detection dataset was used for this. Images are resized to a set resolution and then put through several augmentation techniques: shearing, rotation by 20 degrees, width and height shifting, zooming, and horizontal flipping. All of this is to diversify the dataset. After that, the images are standardized so they fit what the model expects, and split into three subsets — training, validation, and testing.

The researchers built on a framework by #cite(<shandilya_autonomous_2024>), which used CNN and CapsNet together to detect nail diseases from images. That original model learned patterns through a Convolutional Neural Network (CNN), then relied on Capsule Networks (CapsNet) to better capture shapes and spatial features.

What the researchers changed was the model itself. They replaced CNN-CapsNet with a Vision Transformer (ViT). Vision Transformers break images into smaller patches and learn relationships between them, which means the model can pick up on both fine details and the broader structure of an image. CNNs focus on nearby pixels. ViTs can attend to the whole image at once. That is a meaningful difference.

The scope of classification was also expanded. The original framework handled 6 nail classifications. This study pushed that to 10 — beau's line, blue finger, clubbing, healthy nail, koilonychia, melanonychia, muehrcke's lines, onychogryphosis, pitting, and terry's nail.

And the study went further than just classification. Each nail condition was connected to possible systemic diseases — cardiovascular disease, anemia, cancer, among others. So the model does not only recognize what a nail condition looks like. It also suggests what underlying health issues might be involved.

#figure(image("/img/agile.png"), caption: flex-caption(
  [AGILE Development Cycle #cite(<okeke_agile_2021>, form: "normal")],
  [AGILE Development Cycle],
)) <agile>

@agile shows the AGILE development cycle — six phases: Requirements, Design, Development, Testing, Deployment, and Review. The researchers used this cycle to manage the project and adapt as things changed during the research process. Agile made sense here because it supports building things in steps and lets you improve based on what testing and feedback reveal. The models for detecting nail biomarkers (ViT and CNNs) and predicting disease risk (Bayesian inference) were built during the Development phase. Testing came next, where accuracy and performance were evaluated. For Deployment, the researchers went with Flask, a lightweight web framework, to put together an interface where users can upload fingernail images and get predictions. Nothing complicated, just functional. The Review phase was where results got assessed and refinements were planned. Working in cycles like this meant each part of the system was built, tested, and then improved before moving on. And that, at least in part, is what made the final product more reliable.


==== Conceptual Framework
The conceptual framework provides a practical workflow for implementing the theoretical foundation, detailing the process from data collection to system deployment. It is divided into three phases: input, process, and output.

#figure(
  image("img/ConceptualFramework.png", width: 100%),
  caption: [Conceptual Framework of the Study],
) <conceptual-framework>

@conceptual-framework lays out the process. It starts with input, gathering at least 3,000 labeled fingernail images from Roboflow, all at 224x224 resolution or higher. From there, the images go through cleaning: resizing, normalization. Augmentation follows to expand the dataset — flipping, scaling, and adjusting brightness. Feature extraction is handled by four CNN architectures: ResNet-50, VGG-16, RegNetY-16GF, and EfficientNetV2. Training uses 80% of the data, testing uses the remaining 20%, and classification relies on CNNs with literature-based inference layered on top. The researchers tuned hyperparameters based on sensitivity, recall, and confidence intervals, then picked whichever model performed best. What comes out of the system are probabilistic classifications of nail disorders, estimated likelihoods of systemic diseases (e.g., "diabetes: 85%"), and recommendations to consult a doctor. The whole thing is deployed as a web application to make it broadly accessible.

// As illustrated in @conceptual-framework, input phase involves collecting a minimum of 3,000, 224x224 Resolution labeled fingernail images dataset from Roboflow. The process phase includes data cleaning (resizing and normalization) and augmentation (flipping, scaling, brightness adjustment) to enhance dataset diversity. Feature extraction using CNNs including ResNet-50, VGG-16, RegNetY-16GF, and EfficientNetV2, precedes model training with a split dataset (80% training, 20% testing), employing CNNs for classification and literature based inference. Evaluation metrics (sensitivity, recall, confidence intervals) guide hyperparameter tuning, leading to the selection of the best-performing model. The output phase delivers probabilistic classifications of nail disorders, systemic disease likelihoods (e.g., diabetes: 85%), and recommendations for medical consultation, with deployment into a web application for global accessibility.

// (Desktop Application) and Web Application

// The classification of the nail only revolves around 10 labels.
//
// The classification of the nail only revolves around 10 labels.
// We have not acquired datasets of the probabilities of systemic diseases based on nail biomarkers. Thus, we resort to probabilities from literature
//

=== Scope and Limitation of the Study
The scope is the domain of the research. It describes the extent to which the research question will be explored in the study. Delimitations are the factors or aspects of the research area that the researchers exclude from the research. #cite(<aje-scope>, form: "normal"). The research limitations are the practical or theoretical shortcomings of a study that are often outside of the researchers' control#cite(<aje-limitations>, form: "normal")

==== Scope
The following scope are set by the researchers:
- The research is scheduled over a seven-month period, covering phases such as data collection, preprocessing, model development, evaluation, and deployment
- The study covers classifying nail features ranging 10 classes: Beau's Lines, Blue Nails, Clubbing, Healthy Nail, Koilonychia, Melanonychia, Muehrcke's Lines, Onychogryphosis, Pitting, and Terry's Nails.
- The image dataset was trained on five models: Resnet-50, VGG-16, RegNetY-16GF, EfficientNetV2-S, and SwinV2-T. The researchers improved the model through iterative experimentations.
- The researchers implemented explainability techniques such as GradCAM, ScoreCAM, GradCAMPlusPlus, AblationCAM, and feature maps to understand how the model came up with the classified nail.
- The study makes inferences using Bayesian inference with probabilities derived from the curated statistical dataset.
- The study was developed on the web using frameworks like Flask.

==== Delimitations
The following delimitations are set by the researchers:
- The developed model does not explicitly identify specific anatomical features of the nail, such as the lunula, nail bed, or nail color. Instead, it leverages the CNN and ViT architectures to automatically learn and detect relevant patterns and features from the labeled dataset, ranging from subtle changes like Muehrcke’s lines to distinct characteristics like onychogryphosis.
- The developed system is not intended to function as a diagnostic tool. Unlike dermatologists or internal medicine physicians who incorporate a patient’s full medical history, laboratory results, and clinical examinations into their assessment, this system relies exclusively on statistical associations between nail features and systemic diseases. Consequently, its inferences are based on general probabilities rather than individualized medical data, which may oversimplify the complexity and multifactorial nature of systemic diseases.
- The model did not analyze how severe a nail feature has become. It only classifies which nail feature it is.


==== Limitations
The study has the following limitations:
- Nails alone are not reliable indicators of systemic disease. You need more context — the patient's history, their occupation, pathology results. Without that, the picture is incomplete.
- Dataset quality and how balanced the classes are will affect predictions. That is hard to fully control.
- Publicly sourced datasets may not have been verified by licensed medical professionals. Inaccurate labels are a real risk, and they can undermine both classification and inference.
- Epidemiological data on how often nail features appear and their ties to systemic diseases in the local population may be scarce, or may not exist at all.
- Deep learning models are black boxes. The ones used here have limited interpretability, and that can erode clinical trust — even when the model performs well #cite(<doshi_2017_towards>, form: "normal").
- Training complex models takes serious computational resources. That limits how much hyperparameter tuning the researchers could realistically do.

=== Significance of the Research
This study provides a non-invasive, accessible tool for early detection of systemic diseases through fingernail biomarkers. It fills gaps in preventive healthcare and gives people a way to act sooner rather than later. The results are relevant to the following groups:

===== Global Community
People in remote or resource-limited areas can access early health risk assessments without needing a specialist visit. That helps close gaps in healthcare access and encourages people to seek medical advice when it matters.

===== Healthcare Providers
Doctors can use the system as a first-pass screening tool — a way to flag patients who might need further evaluation. In settings where time and resources are tight, that kind of prioritization helps.

===== Public Health Organizations
The system supports monitoring health at a population level. Spotting disease prevalence patterns early feeds directly into building more targeted interventions and shaping public health policy.

===== Researchers
This study lays a foundation for future work in AI-driven diagnostics. It demonstrates how deep learning and probabilistic modeling can be combined for medical use, and that is something others can extend.

===== Underserved Populations
Communities in remote or economically disadvantaged areas benefit from a tool that requires no specialized equipment. It promotes health equity and narrows the gap in healthcare access — at least for initial screening.

===== Health Tech Developers
The project is, in effect, a blueprint. It shows how to build a scalable, AI-driven health solution, and it can inform future preventive healthcare technologies.

===== Policy Makers
The findings can guide decisions about integrating AI tools into healthcare systems, particularly around early detection and access to preventive care at a broader scale.

===== Educational Institutions
Medical and technology students can use the system as a hands-on example of how AI intersects with healthcare. It works well for interdisciplinary learning — the kind that bridges computer science and medicine.

#metadata("Chapter 1 end") <ch1-e>
#pagebreak()

#metadata("Chapter 2 start") <ch2-s>
#chp[Chapter II]
#h2(outlined: false, bookmarked: false)[Review of Related Literatures]

This chapter looks at research from books, websites, magazines, and expert sources to get a better handle on the study. It covers literature and projects from different researchers that connect to how this study was done. The material here helps get familiar with other work that's a lot like this one.

=== Early Diagnosis in the Countryside
Millions of people have nail diseases. Some of these problems point to deeper health issues, as #cite(<prajeeth_smart_2023>) points out. Catching them early—both the nail issue and whatever’s causing it—improves the odds of recovery. Sometimes by a lot.

With something like melanoma, finding it late is a disaster; survival rates just collapse. But people in rural areas often can't see a dermatologist. And the diagnostic tools specialists use aren't there either. Automated systems are supposed to fill that void #cite(<alruwaili_integrated_2025>, form: "normal").

A related point from #cite(<yang_multimodal_2024>) is that a lot of diseases go undiagnosed even when the symptoms are obvious. AI diagnostic systems are starting to change this. They can make recognition faster and more accurate, especially for skin problems. In some studies, they've done as well as—or even better than—trained dermatologists.

Untreated nail infections are not a small thing. The effects can be anything from a little discomfort to system-wide health problems. Research that pinpoints risk factors, sees how infections spread, and tests ways to prevent them is what allows for evidence-based action. And that action is what fuels educational programs and public health campaigns about nail care #cite(<ardianto_bioinformatics-driven_2025>, form: "normal").

=== Nail Problems as Signs of Sickness
Nails are structurally complex, and that complexity makes them useful markers for general health. According to #cite(<shandilya_autonomous_2024>, form: "prose"), nail changes show up with a wide range of diseases — cancer, skin conditions, respiratory issues, heart problems. Their study built a classification system based on nail anatomy to improve the accuracy of skin diagnoses. Looking closely at conditions like onychogryphosis, cyanosis, clubbing, and koilonychia sharpens a dermatologist's exam and can flag bigger issues. Hypoxia, iron-deficiency anemia, those kinds of things. Nail changes also appear in chronic conditions: pitting in psoriasis, onycholysis in eczema.

#cite(<abdulhadi_human_2021>) reached a similar conclusion. Color and shape changes in nails can point to diseases elsewhere in the body. A white spot, a pinkish stain, a wrinkle — any of those might trace back to a liver, lung, or heart problem. Doctors already check nails as part of their assessment. Pink, smooth nails with even color usually mean things are fine. Anything off in how a nail grows or looks could signal something deeper. But here is the limitation with visual inspection: the human eye is subjective about color, has limited resolution, and might miss a tiny change across a few pixels. That leads to wrong conclusions. Computers catch small color shifts that people would not notice.

Beau's Lines are a good example. #cite(<cosar_sogukkuyu_classification_2023>) described them as horizontal depressions that start at the base of the nail and move outward from the lunula. The width of the lines gives a rough idea of how long the underlying condition has been present.

Diagnosing Beau's Lines comes down to examining the nail plate for those sideways dips, as #cite(<lee_optimal_2022>) stated. Ultrasound can help visualize the defect and estimate when whatever caused it started. On the AI side, #cite(<shih_classification_2022>) used an AlexNet with Attention model to classify Beau's lines and got 86.67% accuracy.

Blue finger — cyanosis — is another condition worth noting. #cite(<mahajan_artificial_2024>) described it as rare and mostly harmless, with no clear cause in some cases. It presents as a sudden bluish discoloration on the fingers, sometimes painful. What it signals is that organs and tissues are not getting enough oxygenated blood. The underlying causes vary. Cyanosis comes from lower oxygen levels, specifically a buildup of deoxyhemoglobin in the small blood vessels. Central cyanosis shows on mucous membranes and limbs, often tied to congenital heart diseases. Peripheral cyanosis is usually caught by checking the nails and fingers — blood vessels constrict, blood flow drops, and that happens with cold exposure, shock, congestive heart failure, or peripheral vascular disease.

#cite(<pankratov_nail_2024>) added that the color change can also link to liver cirrhosis or poisoning from substances like cyanide or copper salts. Cyanosis of the nail bed specifically can come from spastic states and decompensated mitral valve defects.

Clubbing is another one. #cite(<pankratov_nail_2024>) describes it as fingers shaped like drumsticks with nails that look like watch glasses — sometimes called hippocratic nails. Hippocrates first documented this back in the 1st century BC, in patients with pleural empyema. The nail plate curves more than normal in both directions, and the free edge tends to bend downward.

#cite(<desir_nail_2024>) defines clubbing as thickening at the end of the finger that gives it a bulbous appearance. Soft tissue in the nail bed increases, and the angle between the nail fold and the nail bed disappears. Early on, you see redness around the nail and a spongy feel. Later, the fingertip gets thick and bulbous, the nail and surrounding skin turn shiny, the nail fold reddens, and ridges appear along the nail plate. More blood vessels become visible, giving the nail bed a lilac tint.

#cite(<john_digital_2023>) noted that clubbing can show up as a clinical sign in Complex Regional Pain Syndrome. In CRPS, the affected limb may also have overactive sympathetic nervous system signs — cold and bluish skin, muscle wasting, tremors, brittle nails.

Several studies have documented the common causes. #cite(<gollins_nails_2021>) stated that simple nail clubbing is most often from an acquired thoracic disease. #cite(<hsu_automated_2024>) found many causes tied to cardiopulmonary conditions: lung cancer, COPD, cyanotic congenital heart disease, idiopathic pulmonary fibrosis. #cite(<desir_nail_2024>) agreed, pointing to respiratory disease as a frequent factor. Around 30% of patients have pulmonary disease. Cardiovascular conditions like congenital cyanotic heart disease, gastrointestinal diseases such as inflammatory bowel disease, endocrine disorders including Graves' disease, and sometimes hereditary clubbing have all been linked to it as well.

#cite(<desir_nail_2024>) went deeper, looking at 407,333 adults. Of those, 85 had a nail clubbing diagnosis — an overall prevalence of 0.03%. Among the clubbing group, 63.53% had pulmonary disease, compared to 36.47% of controls who did not. Across the full sample, roughly 22% had chronic liver disease, 17% had hypothyroidism, 8% had HIV, 5% had congenital heart disease, and another 5% had Graves' disease or hyperthyroidism. One finding stood out: men with clubbing had lower odds of a co-occurring respiratory disease diagnosis than women (odds ratio $0.37$; 95% confidence interval $0.14–0.92$, $p=0.03$).

Healthy nails are not a nail abnormality, but the researchers included them as a baseline class for training the AI model anyway. Healthy nails are pink, smooth, consistent in color — see-through, hard, and essentially colorless. The pink comes from the vascularized nail bed underneath. The lunula, that white half-moon shape, is the visible end of the nail matrix #cite(<abdulhadi_human_2021>, form: "normal").

Koilonychia is in the dataset too. These are "spoon-shaped" nails — brittle, thin, concave. It can affect any age group and usually connects to severe, chronic iron deficiency. The causes behind that deficiency range widely: poor diet, parasitic infections, cancers, among others. Treatment targets whatever is driving the anemia, and the nail changes should resolve once the underlying problem is addressed. Koilonychia is relatively rare in developed countries, so when it does show up, a thorough physical exam and clinical workup are recommended — its presence could point to something significant #cite(<almaguer_koilonychia_2023>, form: "normal").

Melanonychia was also included. According to @racelis_what_2025, a brown or black stain on a fingernail or toenail is called melanonychia — literally "black nail." It shows up as a dark line on one or more nails, and the color can range from solid brown to black. Melanin causes the discoloration, the same pigment behind skin and hair color. Nails are normally clear, and the keratin-producing cells in the nail bed do not produce much melanin under typical conditions. But melanocytes can become active or proliferate, and when they do, a light-to-dark stain appears on the nail.

The most common type is longitudinal melanonychia (LM), as @aseri_basic_2022 explained. LM presents as a linear band running from the proximal nail fold — the matrix — out to the free edge of the nail. It happens because too much melanin accumulates in the nail plate, and the mechanism behind that is either melanocytic activation or melanocytic hyperplasia. With activation, the melanocytes are normal in number but produce more melanin than usual. Hyperplasia means there are actually more melanocytes. Getting that distinction right matters because it is the starting point for categorizing the different types of melanonychia.

The differential diagnosis for LM covers a lot of ground. Benign causes are far more common — ethnic pigmentation, drug-induced pigmentation, benign growths like lentigines and nevi #cite(<adigun_melanonychia_2024>, form: "normal"). On the malignant side, @mio_establishment_2025 points to subungual melanoma, a form of acral lentiginous melanoma, as the primary concern. It makes up 1–3% of melanomas in predominantly white populations but reaches up to 30% in people with darker skin. Rarer malignant causes include squamous cell carcinoma of the nail matrix #cite(<lallas_seven_2023>, form: "normal") and onychopapilloma #cite(<bertanha_differential_2024>, form: "normal"). Non-melanocytic sources have to be considered too — subungual hematomas from trauma, color changes tied to fungal infections #cite(<ricardo_evaluation_2025>, form: "normal").

#cite(<dugan_management_2024>) documented one disease linked to melanonychia: Acral lentiginous melanoma (ALM). ALM is the rarest of the four main cutaneous melanoma subtypes, accounting for 2–3% of all melanomas. It appears mostly on non-hair-bearing skin at the ends of limbs — palms, soles, nailbeds. RJ Reed first described the subtype in 1976 as pigmented lesions with a radial, lentiginous growth phase of melanocytes that eventually transitions into a vertical, dermal invasive stage. ALM differs from other cutaneous melanomas in several ways. It has a much lower mutational burden, fewer activating mutations in BRAF and NRAS, variable KIT mutations, and no UV-related mutational signatures. Mechanical stress — pressure, trauma — might contribute to advanced ALM in the lower limbs, though the evidence on that is mixed. Diagnosis is difficult. ALM can mimic benign conditions like ulcers, diabetes-related lesions, warts, or traumatic injury.

@rodriguez-cerdeira_fungal_2024 showed that certain fungi can cause "fungal melanonychia," a rare form of onychomycosis. These fungi produce melanin themselves. Trichophyton rubrum, specifically the melanoid variant, is the most common cause at 55% of cases. Neoscytalidium dimidiatum accounts for 8%, and Fonsecaea pedrosoi shows up as well. The pigmentation comes from a melanin-like substance the fungus deposits directly into the nail plate. Diagnosis relies on direct examination and culture. Dermoscopy can sometimes reveal specific patterns — yellow-white spots, multicolor pigmentation.

Melanonychia is also among the most frequent nail changes in people living with HIV/AIDS. @flores-bozo_nail_2022 found longitudinal melanonychia in about 25.3% of patients. Most of those cases — 24.4% — were racial melanonychia, consistent with the fact that 70% of participants had Fitzpatrick skin type IV. But treatment plays a role too. One case (0.5%) was connected to zidovudine, an antiretroviral drug. Combined antiretroviral therapy is effective against HIV, but it can also increase the risk of infectious and noninfectious nail conditions, longitudinal melanonychia included. Given how common these nail changes are and how many different things can cause them, regular nail checkups matter for people with HIV.

Muehrcke's Lines are another classification the models need to identify. #cite(<mahajan_artificial_2024>) described them as double white lines running horizontally across the fingernails. They tend to show up on several nails at once, though the thumbnails are usually spared. The white bands stretch all the way across from side to side and are clearest on the second, third, and fourth fingers. Between the lines, the nail bed looks healthy. The lines do not move forward as the nail grows, they do not indent the nail surface, and pressing on the fingernail makes them temporarily disappear.

Low albumin is the underlying link. Albumin is a blood protein produced by the liver, and while liver disease is the most common reason for low levels, plenty of other systemic conditions can cause it too. Muehrcke's lines have been documented in patients with cancer after chemotherapy, kidney disease — nephrotic syndrome, glomerulonephritis — liver disease including cirrhosis, and severe malnutrition from an unbalanced diet #cite(<mahajan_artificial_2024>, form: "normal").

Onychogryphosis, sometimes called ram's horn nail, is also in the dataset. #cite(<mahajan_artificial_2024>) described it as a disorder caused by slow, uneven nail plate growth — one side grows faster than the other. The nail plate thickens, turns opaque and yellow-brown, and curves increasingly as it elongates. The name fits. The nails end up looking like horns or claws.

Pitting is next. Nail pitting shows up as depressions or dimples on fingernails or toenails — shallow or deep holes that can look like white spots or marks. Some cases look like the nail was struck with an ice pick. Pitting is also associated with alopecia areata, an autoimmune condition that causes hair loss #cite(<mahajan_artificial_2024>, form: "normal").

The last classification is Terry's nails. #cite(<lin_development_2021>) described them as nails with white opacification, no visible lunula, and a normal distal band. Dr. Richard Terry first identified them in 1954 in patients with hepatic cirrhosis. Since then, they have been linked to congestive heart failure, chronic kidney disease, diabetes mellitus, and malnutrition. Usually all the fingernails are affected.

#cite(<rowe_nail_2025>) adds that Terry's nails feature leukonychia covering nearly the entire nail bed, with only the last 1 to 2 mm retaining normal color. The strongest association is with hepatic cirrhosis — in one study, 25.6% of cirrhosis patients had them.

Terry's nails are considered one of the most reliable physical signs of cirrhosis and can be an early indicator of autoimmune hepatitis. But they also show up in chronic renal failure, congestive heart failure, hematologic disease, and adult-onset diabetes. And sometimes they just come with normal aging #cite(<chiacchio_atlas_2024>, form: "normal").

=== Limits of Old-School Diagnostics in Rural Places
// NOTE: Might add more studies
Traditional diagnostics in rural areas run into several problems: limited equipment, not enough specialists, natural variation in how different clinicians read the same symptoms, and the sheer difficulty of interpreting complex cases. #cite(<nirupama_mobilenet-v2_2024>) pointed out that dermatological expertise is hard to access in underserved and remote regions. The traditional methods for classifying skin disease rely heavily on human judgment, and that judgment is subjective — different clinicians can reach different conclusions from the same presentation. Automated and computer-aided systems could fill that gap. Machine learning, deep models in particular, has already shown solid results in automating diagnostic procedures for skin disorders.

#cite(<dhanashree_fingernail_2022>, form: "prose") raised a related point about nail-based diagnosis specifically. You can diagnose diseases from fingernail color, but accuracy breaks down because people make assumptions with the naked eye. Human vision has limited resolution. A small color shift across a few pixels on a nail might go completely unnoticed, and that leads to wrong conclusions. A machine picks up on those changes. Thickness, length, color, texture — all of it can be measured computationally in ways the human eye cannot match.

=== Deep Learning and Image Processing for Nail Analysis
VGG-16 and VGG-19 show up a lot in this space. They are lightweight, well-tested on image classification benchmarks, and often used as feature extractors or starting points. @shandilya_autonomous_2024 built a custom four-block CNN but compared it against VGG-19, which reached 89.37% accuracy across six nail disorders. @marulkar_enhancing_2025 put VGG-16 at 87.5%, while @ccaso_detection_2024 got 77% in a different classification task. Newer architectures are pulling ahead, though. @navarro-cabrera_machine_2025 found DenseNet169 outperforming VGG-16 on iron deficiency anemia detection — 71.08% accuracy versus 64.77% recall — and that points to dense connectivity having an edge over sequential layering for subtle medical problems.

#cite(<shandilya_autonomous_2024>, form: "prose") built a Base CNN first, then developed a Hybrid Capsule CNN on top of it. The capsule layers improved how the model captures spatial hierarchies and handles transformations, and the results reflected that. On the Nail Disease Detection dataset, the Hybrid Capsule CNN hit 99.25% accuracy against the Base CNN's 97.75%. In a domain where getting the classification right matters for treatment, that gap is significant.

#cite(<ardianto_bioinformatics-driven_2025>, form: "prose") applied CNNs to 17 classes of nail conditions and reached 83% overall accuracy. A 0.2 dropout rate controlled overfitting, and a 0.001 learning rate balanced convergence speed with training stability. Validation error landed at 0.1037 — low enough relative to training error to show the model generalizes. "Leukonychia" and "Splinter Hemorrhage" were detected accurately, likely because their visual patterns are distinct. "Pale Nail" and "Alopecia Areata" were harder. Those classes probably need more data and better feature extraction to improve.

#cite(<lahari_cnn_2023>, form: "prose") put an Artificial Neural Network against a CNN based on DenseNet121. The CNN won on accuracy and sensitivity. Specificity came out about the same. Their system classifies diseases from nail color and pattern, picking up on small variations that human eyes tend to miss — and that is what gives it a higher success rate than manual inspection.

#cite(<sharma_fingernail_2024>, form: "prose") paired VGG16 with a Random Forest classifier for nail-based health assessment. The hybrid model hit 97.02% accuracy classifying nail images into categories like kidney disorder, melanoma, and anemia, outperforming other classifiers across precision, recall, and F1-score. VGG16 does the feature extraction, which keeps detection reliable. The approach is non-invasive and scales well. The downsides are a limited dataset and narrow disease coverage. Expanding the data, adding more diseases, testing architectures like ResNet, and building in robustness for variable image quality would all be natural next steps.

ResNet-50 and the broader ResNet family have appeared frequently. Skip connections are the key innovation — they let the network train much deeper without running into vanishing gradients. In some comparisons, ResNet-50 comes out ahead of other established models. @marulkar_enhancing_2025 benchmarked several architectures for nail disease classification and found ResNet50 and DenseNet201 both reaching 96.39% precision, well above VGG-16's 87.5%.

EfficientNet represents a different direction — optimizing for both performance and efficiency by scaling depth, width, and resolution together. The goal is decent accuracy with fewer parameters. @can_diagnosing_2022 applied Noisy-Student weighted EfficientNet-B2 variants to a 17-class nail disease task and got 72% accuracy, a hard problem. @ebadi_jalal_abnormality_2025 pushed this further with CE-NFCNet, built on EfficientNet-B0 using cascade transfer learning. On a smaller nailfold capillaroscopy dataset, the network hit perfect scores — 1.00 for precision, recall, accuracy, and AUC — and dramatically outperformed both scratch-trained models and single transfer learning approaches. That result shows what happens when you pair EfficientNet with more sophisticated learning strategies in a specialized medical imaging context.

CNNs still dominate, but Vision Transformers are starting to appear. Self-attention lets ViTs process the whole image at once and pick up on global cues, while CNNs are limited to local receptive fields. @garaiman_vision_2022 trained a ViT on nailfold capillaroscopy images to diagnose microangiopathy in systemic sclerosis patients and got good results. @roy_vision_2022 used a ViT for feature extraction when classifying Yellow Nail Syndrome. @garaiman_vision_2022 later built a practical screening tool for rheumatologists using the same approach. These are promising examples, but ViTs have not caught up to CNNs in popularity for nail analysis. Most of the published work still relies on convolutional architectures because of their maturity and interpretability. The transformer contribution to this field is still developing.

=== Probabilistic Modeling and Explainable AI
Bayesian methods and probabilistic modeling are gaining traction in Explainable AI (XAI) — mainly because they can quantify uncertainty and offer a clearer window into how models arrive at decisions. That matters most in high-stakes fields where understanding the reasoning behind a prediction isn't optional.

@zhou_combining_2025 points out that Bayesian inference brings several advantages over standard black-box neural networks when it comes to agent decision-making (robotics, simulative agents, and similar domains): data-efficiency, generalization, interpretability, safety. All of these tie back, directly or not, to how Bayesian inference handles uncertainty. Other analyses of Bayesian applications make a related point — probabilistic outputs don't just tell you _what_ a model predicts, they give insight into _why_ #cite(<ma_advances_2021>, form: "normal"). Decision-makers can look at the confidence behind a prediction and judge whether to trust it. That lines up with what XAI is trying to do: make complex model decisions understandable to the people relying on them. In healthcare and finance especially, if users can't follow the reasoning, trust breaks down — and so does adoption #cite(<hsieh_comprehensive_2024>, form: "normal").

One of the biggest strengths of pairing probabilistic methods with XAI is uncertainty estimation. Most deep learning models handle this poorly. Deep neural networks are good at learning patterns, but when you try to get practical uncertainty estimates out of them, the results tend to fall short. Their entangled internal representations create a messy problem — localized explanation techniques end up pointing to multiple unrelated features, which undermines the whole point of interpretability #cite(<hu_enhancing_2024>, form: "normal"). Probabilistic neural networks that use variational inference take a different approach, estimating uncertainty through weight distributions rather than fixed point estimates #cite(<bera_quantification_2025>, form: "normal"). Bayesian models are, at least in principle, well-suited for explainable AI because uncertainty quantification is built in #cite(<phdprima_research_ai_2025>, form: "normal"). And that matters because properties like proper calibration, robustness, and interpretability are still missing from a lot of deep learning systems #cite(<leeuwen_uncertainty_2024>, form: "normal").

Interpreting Bayesian results in detail is still difficult, though. Take Bayesian cluster analysis — researchers like it because it captures uncertainty in the partition structure, but actually summarizing the posterior distribution over clusterings is a hard problem. The space is discrete, unordered, and massive in dimension #cite(<balocchi_understanding_2025>, form: "normal"). So even when Bayesian methods produce useful uncertainty information, making sense of it remains a challenge that needs better tools.

Probabilistic programming languages (PPLs) help here. They give researchers structured ways to define models and run automated inference, particularly through efficient Markov Chain Monte Carlo (MCMC) sampling #cite(<ito_what_2023>, form: "normal"). That makes it easier to explore prior and posterior distributions, which is where you learn about a model's parameters and what its predictions actually rest on.

Attribution is another area where probabilistic methods show up. The question is how much each input or factor contributes to an outcome when there's uncertainty involved. #cite(<rodemann_explaining_2024>) built ShapleyBO, a framework that uses game-theoretic Shapley values to break down each parameter's contribution to a Bayesian optimization acquisition function — separating out what explores aleatoric versus epistemic uncertainty #cite(<rodemann_explaining_2024>, form: "normal"). #cite(<li_shapley_2023>) proposed P-Shapley, a probability-based Shapley value that relies on predicted probabilities to tease apart the importance of individual data points in classifiers. And from the economics side, #cite(<sinha_bayesian_2022>) developed a Bayesian marketing attribution model that captures known ad effects while also providing usable error bounds on the parameters that matter.

Posterior uncertainty also plays a direct role in improving models and making decisions more reliable, particularly when data is ambiguous. In behavioral science, earlier automation efforts tended to lack both interpretability and any real representation of uncertainty — which raises the risk of errors going unnoticed #cite(<hayden_uncertainty_2021>, form: "normal"). But using posterior uncertainty to flag ambiguities in observed data and schedule targeted human annotations can quickly sharpen the estimates and bring uncertainty down #cite(<hayden_uncertainty_2021>, form: "normal"). Bayesian approaches, because they center uncertainty, tend to produce AI systems that are more dependable and more adaptable. That's especially valuable when data collection is expensive or when it takes expert knowledge to label things correctly.

=== Clinical Applications
Deep learning applied to fingernail biomarkers has expanded considerably since 2021. Researchers have moved past simple nail image classification — the focus now is on detecting systemic diseases. Nail changes tied to anemia, liver disease, and nutritional issues are showing up reliably in recent studies. Transfer learning with models like VGG-16 #cite(<sharma_fingernail_2024>, form: "normal") and DenseNet #cite(<alzahrani_deep_2023>, form: "normal") is a common thread, and these are frequently combined with traditional machine learning to build hybrid models that push accuracy higher. @cosar_sogukkuyu_classification_2023 used VGG-16 to classify Beau's lines, melanonychia, and clubbing from 723 clinical images — 94% accuracy. @hadiyoso_classification_2022 did something similar with transfer learning on VGG-16, classifying koilonychia, Beau's lines, and leukonychia at 96% accuracy.

Iron deficiency anemia has gotten particular attention because of its link to koilonychia (spoon-shaped nails). @navarro-cabrera_machine_2025 captured 909 fingernail images with a smartphone and ran them through DenseNet169 to detect anemia, landing at 71.08% test accuracy — enough to suggest the method works for young adult populations. A more unusual study took a different angle entirely. @zhang_fingernail-based_2025 used metabolomics and found that dodecanoic acid levels in fingernails dropped in a step-by-step pattern as Alzheimer's disease progressed. That wasn't about nail shape or color at all. But it opens up the idea that the chemical composition of nails could serve as a non-invasive biomarker for neurodegenerative diseases too.

There's also growing interest in screening for multiple conditions at once rather than just one. @sharma_fingernail_2024 built a hybrid deep learning model that sorted images into three categories: kidney disorder, melanoma, and anemia. One system, several conditions. Another direction is combining clinical data — patient history, lab results — with image features, since that context tends to improve diagnostic accuracy. Most current models still rely on images alone, though, and that probably limits what they can do compared to models that also pull in medical background #cite(<jeong_deep_2022>, form: "normal"). Big challenges remain even with these advances: there aren't enough large, open, clinically validated datasets; model interpretability is still a problem; and real-world testing is thin on the ground #cite(<kandekar_deep_2025>, form: "normal") #cite(<gaurav_artificial_2025>, form: "normal").

Screening for systemic diseases is the main objective, but deep learning models are also being trained on specific nail disorders. These narrower studies tend to lay the groundwork for larger diagnostic systems and demonstrate that AI can pick up on subtle visual patterns. Fine-tuning pre-trained networks on curated datasets for particular nail conditions is what usually produces the strongest results — the models learn the small details that distinguish one condition from another.

Automated classification of nail disorders has seen real progress. @ardianto_bioinformatics-driven_2025 trained a CNN to classify 17 types of nail disease, including Beau's lines, Bluish Nail, Koilonychia, and Muehrcke's lines, reaching 83% overall accuracy. For clear-cut conditions like Splinter Hemorrhage and Muehrcke's lines, it caught every test sample correctly — even rare ones. @shandilya_autonomous_2024 took a different architectural approach with a Hybrid Capsule CNN for six nail disorders (Blue Finger, Acral Lentiginous Melanoma, and others), hitting 99.25% validation accuracy. The capsule design preserved spatial features better than a standard CNN could. @tolani_human_2025 improved MobileNetV2 to handle 17 nail conditions — Beau's lines, alopecia areata, yellow nails, among them — and showed that data augmentation made the model noticeably more reliable.

Subungual melanoma is where the stakes get highest. @gaurav_artificial_2025 reported that some CNNs could detect melanonychia, but sensitivity for actual melanoma sat at just 53.3%. Not good enough. @chen_development_2022 pushed things forward with an interpretable U-Net segmentation model for dermoscopic nail images — 96.52% Dice score for nail plate segmentation, 87.11% for pigmented spots. They added a rule-based module connecting model outputs to clinical standards, which gave dermatologists concrete guidance on biopsies and follow-ups for suspicious lesions. That's a meaningful shift, moving from classification toward explainable clinical decision support.

Deep learning has been applied to other nail conditions too. @pujari_real_2025 used YOLOv8 to detect onychomycosis (fungal infection), melanonychia, leukonychia, and paronychia — high precision, high recall. Object detection fits these cases well since the conditions tend to appear as visible spots or patches on the nail surface. Nail psoriasis, a chronic inflammatory disorder, is another area where AI is starting to help. @folle_deepnapsi_2023 built a system that predicts the modified Nail Psoriasis Severity Index (mNAPSI) score, and its ratings matched expert assessments closely. @hsieh_mask_2022 applied Mask R-CNN to pick up features like nail pitting and oil-drop discoloration, averaging 91.5% accuracy. Tools like these save doctors time. They also offer a more consistent way to track how treatment is progressing. The range of nail conditions that deep learning can now handle — from cosmetic changes to serious dermatological diseases — shows how adaptable these models have become for both dermatologists and primary care.

The rapid growth of deep learning for fingernail biomarkers reflects the variety of methods researchers are now using. Standard CNNs, transformer-based models, hybrid architectures — the toolkit keeps expanding. Most nail datasets are small, so transfer learning is the default workaround for limited training data. Which model gets chosen depends on the task at hand: classification, segmentation, or object detection. That diversity is itself a sign that the field is getting better at extracting useful features from complex nail images.

Transfer learning has become the go-to strategy for clinical diagnostic models. A pre-trained network — VGG16, ResNet50, DenseNet201 — starts with weights learned from a massive dataset like ImageNet and then gets fine-tuned on a smaller set of nail images #cite(<kandekar_deep_2025>, form: "normal") #cite(<jeong_deep_2022>, form: "normal"). It improves accuracy and cuts training time compared to starting from scratch. @abdulhadi_human_2021, @cosar_sogukkuyu_classification_2023, and @hadiyoso_classification_2022 all used this approach to classify diseases like hyperpigmentation, clubbing, and Beau's lines with strong results. Hybrid models push things further by pairing deep learning feature extraction with traditional machine learning classifiers. @sharma_fingernail_2024 combined VGG16 features with Random Forest classification and reached 97.02% accuracy across multiple nail diseases. @alzahrani_deep_2023 paired DenseNet201 with an SGDClassifier for 94% accuracy. The best solutions, it turns out, don't always come from deep learning alone.

When the task requires marking exact regions — highlighting pigmented areas, outlining specific nail features — segmentation models are the better fit. @chen_development_2022 used a U-Net-based model on dermoscopic nail images, achieving high Dice scores and enabling more precise tracking of pigmented lesions, which matters for catching melanoma early. @hsieh_mask_2022 applied Mask R-CNN to segment and classify nail psoriasis signs like pitting and onycholysis, with strong accuracy that demonstrated instance segmentation's value in dermatology. Object detection is gaining ground too. @pujari_real_2025 used YOLOv8 on nail images to detect onychomycosis, melanonychia, and other conditions with high precision and recall.

Newer architectures are being explored as well. Capsule Networks and Vision Transformers (ViTs) are both showing up in the literature. @shandilya_autonomous_2024 built a Hybrid Capsule CNN that outperformed a standard CNN at classifying nail disorders — the capsule structure preserves layered spatial relationships between features, which helps. ViTs offer something different: self-attention lets them capture long-range patterns across an entire image #cite(<kandekar_deep_2025>, form: "normal") #cite(<gaurav_artificial_2025>, form: "normal"). Data augmentation — rotation, flipping, zooming, brightness adjustments — remains important across most of these studies, especially for preventing overfitting on small datasets #cite(<shandilya_autonomous_2024>, form: "normal") #cite(<cosar_sogukkuyu_classification_2023>, form: "normal") #cite(<tolani_human_2025>, form: "normal").

Progress is real, but deep learning for fingernail biomarkers still faces serious obstacles before it can be used in clinical or forensic settings. The biggest one is data. There aren't enough large, public, clinically validated datasets to go around. Most studies work with small private collections pulled from Kaggle or local sources, and that makes it hard to build models that generalize well. A model trained on images from one clinic, one camera, one demographic group may not hold up when tested with data from somewhere else. @kandekar_deep_2025 called this out directly — poor data diversity and weak generalization are major barriers to real-world deployment.

The "black box" problem is another hurdle. Deep learning models are often difficult to interpret, and doctors are understandably reluctant to trust a diagnosis they can't trace. Explainable AI (XAI) is the response to that. @chen_development_2022 designed a U-Net with a rule-based system that maps outputs to clinical parameters. @folle_deepnapsi_2023 showed strong correlation between AI-generated mNAPSI scores and human ratings, which builds confidence in the results. But without clearer explanations baked into these systems, getting regulatory approval or clinician buy-in will remain difficult.

Validation is the third gap. A lot of studies are still stuck at proof-of-concept — tested on internal data, never on independent datasets. When validation does happen, it tends to use archived samples rather than live clinical environments. There are no standard protocols for image collection, data processing, or reporting, which makes cross-study comparison and meta-analysis nearly impossible. Forensic applications are essentially untouched — no study has tested deep learning on nail biomarkers in that context yet. Closing these gaps is going to take coordinated effort across the research community to build systems that are more robust, more fair, and more transparent.

=== Lightweight AI for Rural Deployment
Lightweight AI has already been used to bring medical testing into rural areas. @guo_smartphone-based_2021 built a smartphone-based malaria diagnostic system — it pairs a low-cost paper DNA test with a deep learning classifier running directly on the phone. No internet needed. The setup analyzes samples and returns results on the spot. In field tests across rural Uganda, it correctly identified over 98% of malaria cases, delivering what amounts to lab-quality diagnosis from a handheld device #cite(<guo_smartphone-based_2021>, form: "normal"). The system does still require special test strips and someone trained to operate it, but it shows that on-device AI paired with simple physical tests can handle local decision support — and even push secure health data through blockchain for disease tracking.

@abdusalomov_accessible_2025 took a different route, focusing on brain tumor detection. They built a lightweight object-detection network for MRI images by swapping out the standard ResNet backbone in RetinaNet for MobileNet with depthwise separable convolutions. That made the model smaller and easier to run on portable hardware. Their version hit an average precision ($"AP"$) of 32.1% on the BRATS dataset, and it actually outperformed larger models when it came to finding small tumors ($"AP"_S = 14.3$) and large ones ($"AP"_L = 49.7$). The reduced computational cost is the real point here — it opens up real-time MRI analysis on low-power devices. Accuracy scores above 81% across different cases suggest this kind of design could expand access to brain imaging in underfunded clinics. One caveat, though: the model has only been tested on benchmark datasets, not in live hospital settings.

What both studies share is a core idea — that simplifying AI models and running them on-device can bring serious diagnostic capability to rural healthcare. Hardware compatibility and the need for more clinical testing are still open problems.

Transfer learning offers another practical path to building resource-efficient models. Instead of fully retraining a large deep learning network, you use it as a feature extractor. @isewon_optimizing_2025 tested this with VGG-16, ResNet-50, and EfficientNet-B0, pulling features from medical images and feeding them into simpler classifiers — Logistic Regression (LR), Random Forests, Naïve Bayes #cite(<isewon_optimizing_2025>, form: "normal").

The results were telling. A simple LR model trained on VGG-16 features reached nearly the same accuracy as a fully trained VGG-16 on medical image classification. But it used far less time and memory. That trade-off matters for devices with limited processing power #cite(<isewon_optimizing_2025>, form: "normal").

The reason this kind of adaptation works is that it piggybacks on features large models have already learned from massive datasets. It's faster to set up and carries less risk than training from scratch. But there are limits. Performance gains shrank when the method hit very imbalanced datasets — which is common in medical data. And the shallow models are only as good as the features the original CNN learned. A lot of these CNNs were trained on ImageNet, not medical images, so that mismatch can hold back how well the whole pipeline actually performs #cite(<isewon_optimizing_2025>, form: "normal").

Other work takes a more direct approach to making models smaller and faster — either by compressing existing ones or designing efficient architectures from the start. @musa_lightweight_2025 reviewed the main compression techniques: pruning, where you strip out unimportant connections or filters from a trained network; quantization, which drops weight precision (say, from 32-bit floats down to 8-bit integers) so the model runs leaner; and knowledge distillation, where a small "student" model learns to mimic a larger "teacher." These all reduce size and speed up inference. The trade-off is straightforward, though — compress too aggressively and accuracy suffers #cite(<musa_lightweight_2025>, form: "normal").

Building lightweight models from scratch is a different path entirely. It takes more design effort upfront, but the payoff can be models that are both capable and efficient. MNet-10, for example, uses just 10 layers and still hit high accuracy across multiple medical imaging tasks #cite(<montaha_mnet-10_2022>, form: "normal"). @singh_healthcare_2024 went further with EO-LWAMCNet, a lightweight CNN built specifically for Internet of Things (IoT) devices — it reached around 95% accuracy predicting chronic liver and brain diseases from sensor data, all without requiring expensive hardware on-site #cite(<singh_healthcare_2024>, form: "normal").

Hybrid designs that mix architectures are showing up more in recent work too. MUCM-Net is one example, built for skin lesion segmentation by combining CNNs for spatial features, Multi-Layer Perceptrons (MLPs) for pattern recognition, and modern state-space models (Mamba) #cite(<yuan_mucm-net_2024>, form: "normal"). It scored a Dice Similarity Coefficient of $0.91$ while needing only $0.055$ GFLOPS — efficient enough for mobile devices in low-resource settings #cite(<yuan_mucm-net_2024>, form: "normal"). @vincent_performance_2025 built a lightweight CNN for skin cancer detection with mobile-first deployment in mind and tested it on a Raspberry Pi and NVIDIA Jetson Nano using TensorFlow Lite. The numbers are hard to ignore: 98.25% accuracy, 0.01-second inference on a Raspberry Pi 5. Fast, offline, affordable. That combination matters #cite(<vincent_performance_2025>, form: "normal").

Most of the research on lightweight diagnostic AI, at least in resource-limited settings, stays within medical imaging — dermatology, radiology, ophthalmology. There is still a noticeable gap when it comes to applying these resource-efficient methods to other kinds of data that are cheaper and easier to collect. Fingernail images are one option that hasn't gotten much attention yet. Nails carry shape and color biomarkers that a regular consumer camera can capture, and those features could, at least in part, support probabilistic screening for systemic diseases.

=== Synthesis
There is a clear need for diagnostic devices that are non-invasive and simple to use, particularly in rural communities where medical specialists are scarce #cite(<prajeeth_smart_2023>, form: "normal") #cite(<alruwaili_integrated_2025>, form: "normal"). Nails, it turns out, carry useful health information. Clubbing, koilonychia, cyanosis, Terry's nails — these changes have been linked to conditions like heart and lung disorders, liver cirrhosis, and iron deficiency anemia across multiple studies #cite(<shandilya_autonomous_2024>, form: "normal") #cite(<abdulhadi_human_2021>, form: "normal") #cite(<desir_nail_2024>, form: "normal").

Deep learning has shown it can detect nail conditions from images, and that supports the direction this study takes. VGG16, ResNet50, and EfficientNet have all performed well in related work, which makes them reasonable architectures to train and evaluate here #cite(<ardianto_bioinformatics-driven_2025>, form: "normal") #cite(<sharma_fingernail_2024>, form: "normal"). Augmenting the data also helps. Other studies confirm it improves model consistency, and the researchers here plan to do the same with their own dataset.

Two gaps stand out in the literature, and this work tries to address both. The first is the "black box" problem — deep learning models can be accurate, but doctors have a hard time trusting something they can't interpret #cite(<kandekar_deep_2025>, form: "normal") #cite(<hsieh_comprehensive_2024>, form: "normal"). Bayesian inference and a hand-curated dataset let the system calculate disease probabilities instead of just labeling an image. That shift matters. It introduces transparency and a way to express uncertainty, which most current models don't offer #cite(<zhou_combining_2025>, form: "normal") #cite(<ma_advances_2021>, form: "normal"). The second gap is deployment. A lot of existing work stops at proof-of-concept and never reaches real-world testing #cite(<kandekar_deep_2025>, form: "normal") #cite(<gaurav_artificial_2025>, form: "normal"). This study goes further by building a working prototype from whichever model performs best, which is what's needed to turn lab-level accuracy into something clinicians can actually use.

What this study does is bring together deep learning and Bayesian reasoning to push diagnostic tools forward — from collecting data and training models all the way through to a functional prototype. The system is meant to be non-invasive and affordable. And the longer-term goal is practical: a screening tool that works in communities where access to specialists is limited, at least in part closing the gap between what's possible in research and what's available in the field.

#pagebreak()
#metadata("Chapter 2 end") <ch2-e>

#metadata("Chapter 3 start") <ch3-s>
#chp[Chapter III]
#h2(outlined: false, bookmarked: false)[Research Methodology]

This chapter covers the methods and materials used to meet the study's objectives — research design, locale, applied concepts and techniques, algorithm analysis, data collection, system development methodology, software tools, system architecture, and software testing.

=== Research Design
The study follows a quantitative research approach, built around measurable outcomes and statistical evaluation of how models perform. It is both experimental and developmental. On the experimental side, different deep learning architectures were tested and evaluated on an augmented dataset of fingernail images. The developmental side involved designing and building an intelligent system that combines image classification with probabilistic inference to detect systemic diseases from nail biomarkers.

The goal, through systematic experimentation and model benchmarking, was to figure out which neural network architectures work best for this classification task. And then integrate the best ones into a web-based application that could actually be used in practice.

=== Locale of the Study
The study was conducted at Laguna State Polytechnic University Santa Cruz Campus, a state university in the province of Laguna, Philippines. It focuses on detecting systemic diseases probabilistically using deep learning on fingernail biomarkers, with the aim of building an application for early health risk screening. Being at LSPU gave the researchers access to the tools and academic supervision they needed.

The primary beneficiaries are people looking for convenient, accessible preventive healthcare. The system was designed to be user-friendly and deployable on digital platforms, which addresses a growing demand for proactive health monitoring. That means not just residents of Sta. Cruz, Laguna and nearby areas — anyone with internet access can use it to run a preliminary health assessment.

The research may also serve as a reference for future researchers, healthcare stakeholders, and developers working on AI-driven early detection tools. By grounding the work in a local academic institution while addressing global health accessibility, the project aims to contribute to both scientific literature and real-world healthcare practice.

=== Applied Concepts and Techniques
The study draws on machine learning and software engineering techniques to build a reliable, scalable system for detecting systemic diseases through nail image classification. The concepts are organized by theme to make clear what role each plays in the development process.

==== Machine Learning
According to #cite(<geeksforgeeks-2025a>), machine learning is a branch of artificial intelligence where algorithms learn hidden patterns from datasets. Instead of being explicitly programmed for every task, these algorithms can then make predictions on new, similar data.

The researchers used machine learning in this study to pick up on nail changes — some subtle, others more obvious. Nail features like discoloration in blue nails or the shape changes seen in clubbing are hard to capture with rule-based methods. Traditional programming techniques struggle with them too. Deep learning models, though, can learn what these nail features look like directly from images. No one has to spell out every visual rule.

#figure(image("img/machine-learning-geek-for-geeks.png"), caption: flex-caption(
  [Machine Learning #cite(<geeksforgeeks-2025a>, form: "normal")],
  [Machine Learning],
)) <machine-learning>

@machine-learning shows how machine learning models work. Inputs like stock data, customer transactions, streaming data, and email text get fed into the model. From there, techniques like regression handle numerical data while classification sorts categorical data — and the model picks up on patterns during that process. The output is basically the model's best prediction of what should happen, based on what it learned from the training data.

==== Supervised Machine Learning
Supervised machine learning is, according to #cite(<geeksforgeeks-2025b>), one of the core approaches in machine learning and AI. A model gets trained on labeled data — every input has a correct output paired with it. It handles two kinds of problems: classification and regression.

This study deals with classification specifically. The model trains on nail images, each one paired with a label for a nail feature, and from there it picks up on features that let it sort new images it has not seen before into the right categories. That makes it a supervised learning problem.

#figure(image("img/supervised-machine-learning-geek-for-geeks.png"), caption: flex-caption(
  [Supervised Machine Learning #cite(<geeksforgeeks-2025b>, form: "normal")],
  [Supervised Machine Learning],
))<supervised>

@supervised shows how the process works. Labeled data goes in. The algorithm picks up on patterns between the data and the labels — basically figuring out which patterns point to which label. Once trained, the model takes new inputs and predicts labels on its own.


==== Neural Networks
A neural network, as #cite(<ibm-2025a>) puts it, is a model that makes decisions in a way that resembles how the human brain works. Biological neurons identify things and reach conclusions together — neural networks try to do the same thing, roughly. The comparison is simplified, but it gets the point across.

The researchers went with neural networks here because nail image data has complex visual patterns, and neural networks handle that well. Most traditional machine learning algorithms need someone to manually define what features matter. Neural networks do not. They pick up on things like color and texture by going through images pixel by pixel, building up their own representations without being told what to look for.


#figure(image("img/neural-networks-geeks-for-geeks.png"), caption: flex-caption(
  [Neural Network Architecture #cite(<geeksforgeeks-2025c>, form: "normal")],
  [Neural Network Architecture],
)) <neural-network>

@neural-network shows the structure. The figure from #cite(<geeksforgeeks-2025c>) breaks it down — there is an input layer, hidden layers stacked in between, and an output layer at the end. Each node connects to nodes in the next layer, and every connection has a weight attached to it. When a node's output passes a set threshold it fires, sending data forward. Anything below that threshold gets ignored.

==== Deep Learning
Deep learning uses multilayered neural networks — deep neural networks — to simulate how the human brain handles complex decisions #cite(<holdsworth-2025>, form: "normal"). It is a subset of machine learning, but a more powerful one.

People use "deep learning" and "neural networks" interchangeably a lot, and #cite(<ibm-2025a>) points out why that gets confusing. The "deep" part refers to how many layers the network has. More than three layers, counting input and output, and it qualifies as deep learning. Two or three layers is just a basic neural network.

Nail images have a lot going on, texture, color, spatial patterns that vary across samples. That kind of complexity needs multiple hidden layers to pull apart and learn from, which is why the neural networks in this study are deep neural networks.

#figure(image("img/deep-neural-network-ibm.png"), caption: flex-caption(
  [Deep Neural Network Architecture #cite(<ibm-2025a>, form: "normal")],
  [Deep Neural Network Architecture],
)) <dnn>


@dnn shows the architecture of a deep neural network. Unlike basic neural networks, deep neural networks consist of many more hidden layers. Machine learning on these deep neural networks is called deep learning.

==== Convolutional Neural Networks
What sets convolutional neural networks apart, according to #cite(<ibm-2025b>), is how well they handle image, speech, and audio data. They rely on three layer types: convolutional, pooling, and fully connected.

That image performance is why the researchers went with CNNs. They pick up on spatial patterns and local details in images in a way other architectures do not. The convolutional layers learn edges, textures, shapes — and as you go deeper, the network starts recognizing more abstract things like structural abnormalities in nail photos.

#figure(image("img/cnn-developer-breach.png"), caption: flex-caption(
  [Convolutional Neural Network Architecture #cite(<ibm-2025b>, form: "normal")],
  [Convolutional Neural Network Architecture],
))<cnn>

@cnn lays out the CNN architecture. Two main stages: feature extraction, then classification. The image goes through convolutional layers with ReLU activation and pooling layers that reduce spatial size but hold onto the features that matter. Those layers produce feature maps, basically hierarchical snapshots of visual patterns the network found. After that, everything gets flattened and pushed through fully connected layers. A softmax function at the end outputs probabilities across the classes.

The CNNs in this study all follow that same general flow. Where they differ is in depth and how they are configured — number of convolutional and pooling layers, filter count, filter size, and the layout of the fully connected portion.

==== Vision Transformers
ViTs treat images as sequences, according to #cite(<shah-2022>). The input image gets split into patches, each patch flattened into a single vector by concatenating pixel channels and then linearly projecting it to the right dimension. From there, the model learns image structure on its own and predicts class labels.

The researchers wanted to test ViTs because they model global relationships across an entire image instead of relying on local feature extraction the way CNNs do. The question was whether that kind of architecture could offer an edge when classifying nail features. And ViTs do tend to outperform CNNs in general. But they are also more computationally expensive and harder to interpret, so there are trade-offs. Testing both gave the researchers a broader basis for comparing performance and generalization.

#figure(image("img/vit-geek-for-geeks.png"), caption: flex-caption(
  [Architecture and Working of Vision Transformers #cite(<geeksforgeeks-2025d>, form: "normal")],
  [Architecture and Working of Vision Transformers],
)) <vit>

@vit shows the ViT architecture, from #cite(<geeksforgeeks-2025d>). The image gets divided into patches, flattened, and embedded through linear projection. Positional encodings get added so the model knows where each patch sits spatially. Those embeddings then pass through transformer encoder layers — multi-head self-attention and feed-forward networks. At the end, the CLS token's output goes into an MLP for classification.

==== Transfer Learning
Transfer learning takes a model that was already trained on one task and reuses it for a different but related one #cite(<murel-jacob-2025a>). Instead of building everything from the ground up, you start with what the model already knows.

#figure(image("img/transfer-learning.png"), caption: flex-caption(
  [Transfer Learning #cite(<kaya-2022>, form: "normal")],
  [Transfer Learning],
)) <transfer-learning>

There were a few reasons the researchers went with this approach. It cut down on training time. They did not need as much data either. And because the model retains what it learned from its original dataset, retraining it on new data tends to make it generalize better — the knowledge stacks. The pre-trained models here came from `torchvision`, already trained on ImageNet. So before the model ever touched a nail image, it could already pick up on a broad set of visual features.

==== Fine-Tuning
Fine-tuning and transfer learning are related, but they work differently. #cite(<murel-jacob-2025a>) explains that both reuse pre-existing models instead of training from scratch — the difference is in how the model gets adapted. With transfer learning, you freeze the model's weights and use it as a fixed feature extractor, only training a new classifier layer on top. Fine-tuning goes further. You unfreeze part or all of the pre-trained model and keep training on a new dataset that is specific to your task, so the model can adjust its internal representations to fit the target domain better.

The researchers fine-tuned pre-trained models on their nail dataset. The models had already picked up general visual features from ImageNet, and fine-tuning let them adapt those features to the kinds of visual cues that show up in nail images specifically.

==== Multiclass Classification
A classification task with more than two possible outputs is called multiclass classification #cite(<data-robot-2025>, form: "normal"). The dataset in this study contains 10 nail feature classes, so that framework was the obvious fit. Given an input image, the model has to decide which nail feature it is looking at. Every image falls under one category only, but there are ten to choose from.

#figure(image("img/multiclass-classification.png"), caption: flex-caption(
  [Multiclass Classification #cite(<kainat-2023>, form: "normal")],
  [Multiclass Classification],
)) <multiclass-classification>

@multiclass-classification shows a basic example of how this works. There are three classes — triangle, cross, and circle. The model receives an image of an object and predicts which one it belongs to.

==== Image Preprocessing
Image preprocessing is the step where raw images get converted into a format machine learning algorithms can actually process #cite(<geeksforgeeks-2025e>). It has a bigger impact than it might seem — getting it right improves both accuracy and efficiency.

The researchers needed to turn images into numbers. Deep learning models only work with tensors, so that conversion was necessary. Resizing came first, then normalization, then converting to tensors.

==== Image Normalization
Pixel intensity values were normalized to a standard scale #cite(<geeksforgeeks-2025e>, form: "normal"). The study used ImageNet's mean and standard deviation for this: $"mean" = [0.485, 0.456, 0.406]$ and $"std" = [0.229, 0.224, 0.225]$. The pre-trained models from PyTorch's torchvision library were trained on ImageNet, so matching those normalization values keeps the data distributions consistent. That consistency is what makes transfer learning work well and keeps gradients stable while training.

==== Data Augmentation
Data augmentation takes existing data and creates new samples from it to help the model generalize better #cite(<murel-jacob-2025b>). It cuts down on overfitting and makes the model more robust overall.

The researchers applied several augmentation techniques to the nail images — flipping, shearing, rotation, brightness adjustments, and exposure changes. That way the model sees the same nails from different orientations and under different lighting, which helps it handle unseen data better.

#figure(image("img/data-augmentation.png"), caption: flex-caption(
  [Image Augmentation #cite(<murel-jacob-2025b>, form: "normal")],
  [Image Augmentation],
)) <data-augmentation>

@data-augmentation shows what this looks like in practice. One original image gets transformed into multiple variations: flipped, rotated, blurred, exposure-adjusted, contrast-shifted, converted to grayscale. It is a way to stretch a limited dataset further and give the model more diversity to train on.

==== Batch Learning
Batch learning, or offline learning, trains the model on the full dataset in one go @geeksforgeeks_batch_2025. The dataset here was a fixed collection of labeled nail images — nothing coming in live, no updates needed. So batch learning was the straightforward choice. It gave the researchers better stability and reproducibility, and the results were more accurate because of it.

#figure(
  image("./img/batch-learning.png"),
  caption: flex-caption(
    [Batch Learning vs Online Learning #cite(<gaidhane_batch_2023>, form: "normal")],
    [Batch Learning vs Online Learning],
  ),
) <batch-learning-img>

@batch-learning-img shows how batch learning and online learning differ. Gaidhane (2023) points out that the core distinction is the dataset — batch learning works off a fixed one. It runs faster and uses fewer resources. Online learning is more flexible though, since the model picks up new data as it arrives and learns incrementally. That adaptability comes at a cost: it is slower and needs more compute.

==== Class Balancing
Some classes in a dataset end up with far fewer samples than others — certain disease categories might have a handful of images while healthy nails have hundreds. Without balancing, the model just leans toward whatever class has the most data. Kharwal (2021) describes class balancing as the set of techniques used to fix that kind of skew so the model does not learn in a lopsided way.

The researchers used weighted Cross Entropy Loss to deal with this. It adjusts the loss function so that misclassifying an underrepresented class carries a heavier penalty. That pushes the model to pay more attention to minority classes instead of ignoring them.

==== Learning Rate Scheduling
Learning rate schedulers change the learning rate during training instead of leaving it fixed @chugani_gentle_2025. Some follow preset rules, others respond to how the model is performing.

#figure(
  image("./img/reduceLR-scheduler.png"),
  caption: flex-caption(
    [ReduceLROnPlateau Scheduler #cite(<chugani_gentle_2025>, form: "normal")],
    [ReduceLROnPlateau Scheduler],
  ),
)

For this study, the researchers went with ReduceLROnPlateau. It tracks validation metrics and drops the learning rate only when improvement stalls — if validation loss does not get better for n epochs, the rate gets reduced by a set factor. That makes it different from something like StepLR, which just cuts the rate on a schedule no matter what. ReduceLROnPlateau is simpler in practice and adapts to the actual training dynamics.

==== Early Stopping
Early stopping is one of the simplest regularization techniques out there @murel_what_2023. It caps the number of iterations during training.

#figure(
  image("./img/early-stopping.png"),
  caption: flex-caption([Early Stopping #cite(<murel_what_2023>, form: "normal")], [Early Stopping]),
) <early-stopping-img>

@early-stopping-img shows how it works. The model keeps passing through the training data, epoch after epoch, but early stopping cuts it off once there is no meaningful improvement in training and validation accuracy for a set number of epochs. The point is to stop right when the model hits its lowest training error — before validation error starts climbing or flatlines. For the researchers, this saved time and GPU hours on Colab. No point in running more epochs if the model is not getting any better.

==== Evaluation Metrics
Evaluating a model means using metrics to figure out how well it performs — and where it does not #cite(<domino_what_nodate>, form: "normal"). That matters early in research, and it stays relevant when monitoring the model down the line. The researchers relied on several metrics to track how training was going and to compare predictive performance across different experimental setups.

===== Accuracy
Accuracy is the simplest classification metric. It tells you the proportion of predictions the model got right out of everything it predicted #cite(<geeksforgeeks_evaluation_2025>, form: "normal"). With multiple nail feature categories to classify, accuracy gave a useful overall snapshot of how the model was doing.

#figure(
  kind: "equation",
  [
    $"Accuracy" = ("TP" + "TN") / ("TP" + "TN" + "FP" + "FN")$
  ],
  caption: flex-caption(
    [Formula for Accuracy #cite(<geeksforgeeks_evaluation_2025>, form: "normal")],
    [Formula for Accuracy],
  ),
)

===== Precision
Precision asks a different question: of all the times the model predicted a positive, how often was it actually right? That matters when false positives carry a real cost — like in medical diagnosis, where flagging a disease that is not there has consequences. The formula is defined as: 

#figure(
  kind: "equation",
  [
    $"Precision" = "TP"/("TP" + "FP")$
  ],
  caption: flex-caption(
    [Formula for Precision/PPV #cite(<geeksforgeeks_evaluation_2025>, form: "normal")],
    [Formula for Precision/PPV],
  ),
)

where TP is True Positive and FP is False Positive. In multiclass settings, precision is calculated per class and then averaged. The averaging method — macro, micro, or weighted — depends on what you want to emphasize #cite(<sokolova_systematic_2009>, form: "normal").

===== Recall
Recall, or sensitivity, flips the perspective @pedigo_sensitivity_2025. It measures how many of the actual positives the model managed to catch. The formula is defined as: 

#figure(
  kind: "equation",
  [
    $"Recall" = "TP" / ("TP" + "FN")$
  ],
  caption: flex-caption([Formula for Recall #cite(<pedigo_sensitivity_2025>, form: "normal")], [Formula for Recall]),
)

where TP is True Positive and FN is False Negative.

===== F1 score
F1 score is the harmonic mean of precision and recall @geeksforgeeks_evaluation_2025. It rolls both into a single number, which helps when you need the model to do well on both fronts. High F1 means it does. The formula is defined as:

#figure(
  kind: "equation",
  [
    $"F1 score" = 2 times ("Precision" times "Recall") / ("Precision" + "Recall")$
  ],
  caption: flex-caption(
    [Formula for F1 score #cite(<geeksforgeeks_evaluation_2025>, form: "normal")],
    [Formula for F1 score],
  ),
)

===== Confusion Matrix
A confusion matrix is a table that shows how well a classification model is doing @geeksforgeeks_understanding_2025. It lines up the model's predictions against the actual results — where it got things right and where it got them wrong. That makes it easier to spot specific patterns in the mistakes.

#figure(
  image("./img/confusion-matrix.jpg"),
  caption: flex-caption(
    [Confusion Matrix #cite(<geeksforgeeks_understanding_2025>, form: "normal")],
    [Confusion Matrix],
  ),
)

==== Model Interpretability
Model interpretability, as @geeksforgeeks_model_2025 puts it, is about being able to understand and explain how a model arrives at its predictions. With traditional models like decision trees or linear regression, that is fairly straightforward — they are transparent by design. Neural networks are a different story. They are multi-layered black boxes, and figuring out why they made a particular decision is much harder.

The researchers used saliency maps to make their model more interpretable. Saliency maps are built for computer vision — they highlight which parts of an image the model focused on most when making its prediction. That gives a visual explanation of what drove the decision.

#figure(
  image("./img/saliency-map.png"),
  caption: flex-caption([Saliency Map #cite(<geeksforgeeks_what_2021>, form: "normal")], [Saliency Map])
)

=== Algorithm Analysis
The researchers picked a set of architectures that cover different stages of progress in computer vision to evaluate how well deep learning models perform on nail feature classification. Two things guided the selection: architectural diversity, so the models would represent a broad range of design approaches, and established benchmarks — ImageNet Top-1 and Top-5 accuracy, parameter counts, GFLOPs — as reported in the official PyTorch model repository. That gave a standardized way to compare everything, from older convolutional networks to newer transformer-based ones.


==== VGG-16
@simonyan_very_2015 introduced VGG-16, one of the earlier deep CNNs that performed at state-of-the-art level on ImageNet. The design is deliberately uniform — 3×3 convolutional filters stacked on top of each other, max-pooling layers, then fully connected layers at the end. At 138.4 million parameters and 15.47 GFLOPs it is not lightweight. But the simplicity of the architecture made it popular, and it turned out to be effective for transfer learning. Here it serves as a classical baseline to measure newer architectures against.

#figure(
  image("./img/vgg16_architecture.jpg"),
  caption: flex-caption([Architecture of VGG-16 #cite(<hassan_vgg16_2018>, form: "normal")], [Architecture of VGG-16]),
) <vgg-architecture>

@vgg-architecture lays out the model's structure. @hassan_vgg16_2018 describes how VGG-16 takes 224×224 RGB images and pushes them through convolutional layers with 3×3 receptive fields — sometimes 1×1 for channel-wise transforms — using stride 1 and padding to preserve spatial resolution. Between the convolutional blocks, five max-pooling layers (2×2 windows, stride 2) handle spatial pooling. Then come three fully connected layers for classification: two with 4096 channels, and a final layer with 1000 channels capped by softmax. Every hidden layer uses ReLU. Local Response Normalization was left out — it cost memory and compute but did not actually improve results.

==== ResNet-50
ResNet-50 came from @he_deep_2015 and brought residual connections to the table. That solved the vanishing gradient problem, which had been a barrier to training really deep networks. With 25.6 million parameters and 4.09 GFLOPs it is much lighter than VGG-16, and it outperforms it on ImageNet too. It quickly became one of the most common backbones in computer vision — medical imaging especially. In this study it is the "industrial standard" CNN that everything else gets measured against.

#figure(
  image("./img/resnet50_architecture.jpg"),
  caption: flex-caption(
    [Architecture of ResNet-50 #cite(<mukherjee_annotated_2022>, form: "normal")],
    [Architecture of ResNet-50],
  ),
) <resnet-architecture>

@resnet-architecture breaks down the structure. The network is 50 layers deep. It starts with a convolutional layer, then passes through four stages of residual blocks built on a bottleneck design: 1×1 convolution to shrink dimensions, 3×3 convolution for spatial feature extraction, and another 1×1 to expand back. What makes it work are the shortcut connections — they let gradients flow directly across blocks during backpropagation, skipping layers entirely. That keeps training stable no matter how deep the network gets.

==== RegNetY-16GF
@radosavovic_designing_2020 introduced RegNet with a different philosophy — instead of designing individual architectures, they designed the space of possible network designs. The RegNetY family adds Squeeze-and-Excitation blocks for channel-wise feature recalibration. RegNetY-16GF specifically sits at 83.6 million parameters and 15.91 GFLOPs, offering large capacity while staying scalable. It has outperformed EfficientNets under standardized training setups. The researchers initially included it in this study, but ended up dropping it — despite having roughly the same parameter count and GFLOPs as VGG-16, it turned out to be more expensive to train in practice.


==== EfficientNetV2-S
EfficientNetV2, from @tan_efficientnetv2_2021, is the follow-up to EfficientNet and was built for faster training with better parameter efficiency. The "S" variant keeps things small — 21.5 million parameters, 8.37 GFLOPs — while still hitting high accuracy. It uses fused MBConv layers and progressive learning strategies like variable image resizing and adaptive regularization. That balance of accuracy and low resource cost makes it a good fit for healthcare applications where you need efficiency. In this study, it represents the modern efficiency-focused end of CNN design.

#figure(
  image("./img/efficientnet-archi.png"),
  caption: flex-caption(
    [Architecture of EfficientNetV2-S #cite(<zhao_diagnostic_2024>, form: "normal")],
    [Architecture of EfficientNetV2-S]
  )
) <efficientnet-archi>

@efficientnet-archi shows how EfficientNetV2-S is built. @tan_efficientnetv2_2021 describes how it uses training-aware Neural Architecture Search and scaling to optimize for both accuracy and training speed. Fused-MBConv blocks handle the early layers — they train faster — while traditional MBConv blocks take over in later stages for parameter efficiency. The blocks use depthwise separable convolutions with different expansion ratios, plus squeeze-and-excitation optimization. Progressive learning is part of the design too: image size gradually increases during training and regularization adjusts along with it. That speeds up convergence without hurting generalization, which is why it works well for transfer learning when compute is limited.

==== SwinV2-T
Swin Transformer V2 #cite(<liu_swin_2022>, form: "normal") builds on the original Swin Transformer with a few key changes — residual-post-norm and scaled cosine attention — that make training more stable for deeper models. It also fixes the "resolution gap" problem, so pretrained models transfer better to higher resolutions. That matters in medical imaging, where fine details can make or break a classification. The Tiny variant has about 28.4 million parameters and 5.94 GFLOPs, keeping it lightweight compared to the Base or Large versions. Even at that size, it still gets hierarchical self-attention and can model long-range dependencies, which gives it a real advantage as a transformer-based alternative to CNNs for nail feature classification.

#figure(
  image("./img/swinfig.png"),
  caption: flex-caption(
    [Swin Transformer vs Swin Transformer V2 #cite(<rastogi_papers_2024>, form: "normal")],
    [Swin Transformer vs Swin Transformer V2]
  )
) <swinfig>

@swinfig shows the SwinV2 architecture. @liu_swin_2022 describes how it uses shifted window-based self-attention — attention gets computed within non-overlapping local windows, and then the window partitions shift between layers so information can flow across windows. Three main innovations drive the design: residual-post-normalization for training stability, scaled cosine attention instead of dot-product attention for better cross-resolution transfer, and log-spaced continuous position bias that handles different window sizes. The network starts with a patch embedding layer that splits the input into non-overlapping patches, then moves through four stages of Swin Transformer blocks. Patch merging layers between stages reduce spatial resolution while increasing feature dimensionality.

==== ConvNeXt-Tiny
After seeing that RegNetY-16GF was too expensive to train — even with roughly the same parameter count and GFLOPs as VGG-16 — the researchers swapped it for ConvNeXt-Tiny. They needed to run multiple experiments efficiently, and ConvNeXt-Tiny offered a better balance. @liu_swin_2022 introduced ConvNeXt as a CNN that matches or beats Vision Transformers on various benchmarks while keeping the convolutional inductive biases that help with training stability on smaller datasets. The Tiny variant has around 28 million parameters. That made it practical for the kind of resource-constrained setup the researchers were working with on Google Colab.

#figure(
  image("./img/convnextfig.png"),
  caption: flex-caption(
    [ConvNext-Tiny Architecture #cite(<zhao_diagnostic_2024>, form: "normal")],
    [ConvNext-Tiny Architecture]
  )
) <convnextfig>

@convnextfig shows ConvNeXt's architecture. According to @liu_swin_2022, it takes the standard ResNet design and modernizes it by borrowing ideas from Vision Transformers — but stays fully convolutional. The network has four stages in a hierarchical layout, using patchify stems with 4×4 convolutional kernels at stride 4 instead of the usual aggressive early downsampling. Each stage is built from inverted bottleneck blocks with depthwise 7×7 convolutions, LayerNorm, and GELU activations. Compared to traditional CNNs, it uses fewer activation and normalization layers. Separate downsampling layers sit between stages. The result is competitive with transformers, but with simpler training dynamics and convolutional efficiency.

@model-table lays out the ImageNet performance numbers for the models used in this study, all from the official PyTorch repository. Top-1 accuracy measures whether the model's single best prediction is right. Top-5 is more forgiving — the correct label just has to be in the top five. Parameter count and GFLOPs indicate size and computational demand. The difference across architectures is hard to miss. VGG-16 sits at 71.59% Top-1, but it takes 138.4M parameters and 15.47 GFLOPs to run. EfficientNetV2-S pulls 84.23% Top-1 with a fraction of that — 21.5M parameters, 8.37 GFLOPs.

#figure(
  text(size: 10pt)[
    #table(
      columns: (1fr,) * 5,
      align: (x, _) => if x == 0 { left + horizon } else { horizon + center },
      table.header([Model], [Top-1 Accuracy], [Top-5 Accuracy], [Parameters], [GFLOPs]),

      [VGG16], [71.592], [90.382], [138.4M], [15.47],
      [ResNet-50], [76.13], [92.862], [25.6M], [4.09],
      [RegNetY-16GF], [80.424], [95.24], [83.6M], [15.91],
      [EfficientNetV2-S], [84.228], [96.878], [21.5M], [8.37],
      [SwinV2-T], [82.072], [96.132], [28.4M], [5.94],
      [ConvNeXt-Tiny], [82.52], [96.146], [28.6M], [4.46],
    )
  ],
  caption: [Performance on ImageNet of Selected Models from PyTorch],
)<model-table>

==== Training Configuration
The same training setup was used across all experiments — same optimizer, same learning rate scheduling, same loss function. For optimization, the researchers used AdamW #cite(<loshchilov_decoupled_2019>, form: "normal"), which separates weight decay from the gradient update. That tends to generalize better than standard Adam. Learning rate adjustments were handled by ReduceLROnPlateau, which watches validation loss and drops the learning rate by a factor of γ when performance stops improving. This kind of adaptive scheduling helps prevent overfitting and lets the model converge more efficiently — something that matters especially with smaller medical imaging datasets where variance is high. Prior studies have shown ReduceLROnPlateau works well for stabilizing transfer learning in medical image analysis #cite(<rajpurkar_chexnet_2017>, form: "normal"). For the loss function, weighted Cross-Entropy Loss addressed the class imbalance in the nail dataset. Class weights were set inversely proportional to how often each class appeared, so underrepresented classes had a bigger impact on the loss. That keeps the model from just defaulting to majority classes. Weighted Cross-Entropy is a common choice in medical image classification for exactly this reason #cite(<buda_systematic_2018>, form: "normal").

==== Training Strategies
There are multiple ways to adapt a pretrained model to a new domain, and each one involves trade-offs — between computational cost, training stability, and how much the model can learn about the new task. How you choose to train determines how well the model can take what it learned from ImageNet and apply it to something as specific as fingernail pathology images. The researchers tested four strategies: training from scratch, freezing pretrained weights to see how well raw features transfer, full fine-tuning for complete network adaptation, and gradual unfreezing to balance preserving learned features with picking up new ones.

===== Training from scratch
Here the model starts with random weights. No pretrained ImageNet features, no transfer learning — just end-to-end training on the nail dataset. The initial learning rate is higher ($1e-3$) than what fine-tuning uses, the scheduler factor is more aggressive (0.1), and training runs longer at 200 epochs to give the model enough time to learn everything from the ground up. Weight decay is kept lighter at 0.0005 so the model is not over-regularized while it is still in the early stages of learning. This setup acts as a control — it shows what happens when the model has to figure out all the representations on its own, without any prior knowledge.

===== Baseline
The baseline freezes every pretrained weight in the backbone and only trains the classification head. Learning rate is $1e-3$, weight decay is 0.01 — low, since only the head parameters are being updated. The scheduler has a patience of 4 epochs, which keeps it responsive to validation performance without being too jumpy. This tests how far ImageNet features can carry the model on the nail dataset without any fine-tuning at all.

===== Full Fine-Tuning
All layers get unfrozen. Everything updates during training. The learning rate drops to $1e-5$ to avoid catastrophic forgetting — you do not want to overwrite the pretrained features too aggressively. Weight decay is higher at 0.05 for stronger regularization, which matters more with transformer-based models. Scheduler patience goes up to 5 epochs with a 2-epoch cooldown to keep things stable while the entire network adapts. Research in medical image classification has shown that full fine-tuning often beats head-only or partial approaches (e.g., @peng_rethinking_2023 and @davila_comparison_2024), though the risk of overfitting goes up when training data is limited.

===== Gradual Unfreezing
This follows the approach from @howard_universal_2018. Training starts with just the classification head, then earlier layers get unfrozen progressively as training goes on. The learning rate was set to 1e-4 with weight decay at 0.01 and a shorter scheduler patience of 3 epochs so the model can adapt faster as new layers open up. The idea is to prevent catastrophic forgetting by letting the network adjust gradually to the fingernail dataset instead of all at once. The researchers picked gradual unfreezing over other ULMFiT components — like discriminative learning rates or slanted triangular schedules — because it is simpler and more stable for vision-based transfer learning.

==== Hyperparameter Configuration by Training Strategy
@hyperparam-table has the full breakdown of hyperparameter configurations for each training strategy. Every configuration was shaped by the specific needs of its approach, but batch size (32) and random seed (42) stayed the same across all experiments to keep comparisons fair. The reasoning behind each parameter choice is covered in the subsections above.

#figure(
  table(
    align: (x, y) => if x == 0 { left } else { center },
    columns: (2fr, 0.5fr, 1fr, 1fr, 1fr),
    table.header(
      [Parameter],
      [Base],
      [Full],
      [Scratch],
      [Gradual Unfreeze],
    ),

    [Batch Size],
    [32],
    [32],
    [32],
    [32],
    [Epochs],
    [50],
    [50],
    [200],
    [50],
    [Learning Rate],
    [1e-3],
    [1e-5],
    [1e-3],
    [1e-4],
    [Weight Decay],
    [0.01],
    [0.05],
    [0.0005],
    [0.01],
    [Early Stopping Patience],
    [10],
    [15],
    [25],
    [15],
    [Scheduler Factor],
    [0.5],
    [0.5],
    [0.1],
    [0.5],
    [Scheduler Patience],
    [4],
    [5],
    [10],
    [3],
    [Scheduler Threshold],
    [1e-4],
    [1e-5],
    [1e-4],
    [1e-4],
    [Scheduler Cooldown],
    [1],
    [2],
    [2],
    [1],
    [Minimum Learning Rate],
    [1e-6],
    [1e-6],
    [1e-6],
    [1e-6],
  ),
  caption: [Hyperparameter configurations across training strategies]
) <hyperparam-table>

==== Bayesian Inference
Bayesian inference works differently from deterministic fine-tuning. It treats model parameters as random variables and uses Bayes' theorem to update priors with observed data, producing posterior distributions: $p(theta | y) prop p(y | theta) p(theta)$. @gelman_bayesian_2013 goes into the computational side — methods like MCMC, variational inference, and Hamiltonian Monte Carlo. What makes this useful in medical applications is uncertainty quantification; you do not want a model that is overconfident. In the nail disease pipeline, Bayesian inference calculates posterior probabilities of systemic conditions based on detected nail features, pulling in population-level priors and conditional probabilities. It handles limited data well when you have informative priors, though it costs more compute and the priors need to be chosen carefully.

=== Data Collection Methods
The performance and reliability of any machine learning–based diagnostic system depend on the quality and representativeness of the data used for model development. In this study, the researchers curated a labeled dataset of fingernail images to support multiclass disease classification. Additionally, to enable probabilistic inference of systemic diseases from nail features, the researchers organized and processed a complementary statistical dataset that captures the relevant associations between nail characteristics and disease outcomes.

==== Image Dataset
The dataset utilized for this study is sourced from a publicly available Nail Disease Detection collection hosted on Roboflow, and is released under the Creative Commons Attribution 4.0 (CC BY 4.0) license. The dataset comprises a total of 7,264 images, annotated using the TensorFlow TFRecord (Raccoon) format, covering 11 classes of nail diseases. However, the researchers have dropped Lindsay's Nail class due to few number of images.

The researchers decided to revise the name of the class from “acral lentiginous melanoma” to “melanonychia” for medical specificity. As determined from the experts' interview done by the researchers to Dr. Cristine Florentino, acral lentiginous melanoma is a diagnosis in itself and not a finding on a physical exam. Conversely, melanonychia (a hyperpigmentation of the nail plate) is a measurable nail feature, thus making it the more appropriate name for the dataset. Because not all images may have been confirmed to depict acral lentiginous melanoma but they all exhibit features of melanonychia, such a revision allows the dataset to depict clinical specificity and not portray a diagnosis as a finding on the nails.

The final dataset used in this study consists of 7,258 labeled nail images, divided into three subsets: training (6,360 images, 88%), validation (591 images, 8%), and testing (307 images, 4%) as illustrated in @class-distribution. Each subset contains images from ten nail disease classes, with class distributions reflecting a natural imbalance. The training set is used for model learning, the validation set for hyperparameter tuning and early stopping, and the test set for final evaluation.

#figure(
  text(size: 12pt)[
    #table(
      columns: (1.7fr, 1fr, 1fr, 1fr),
      align: (x, _) => if x == 0 { left + horizon } else { horizon + center },
      table.header([Class], [Train], [Validation], [Test]),

      [Beau's Line], [456], [44], [22],
      [Blue Finger], [612], [59], [29],
      [Clubbing], [783], [74], [38],
      [Healthy Nail], [642], [54], [30],
      [Koilonychia], [537], [52], [28],
      [Melanonychia], [753], [70], [36],
      [Muehrcke’s Lines], [336], [31], [16],
      [Onychogryphosis], [690], [65], [34],
      [Pitting], [657], [61], [32],
      [Terry’s Nail], [894], [81], [42],
    )
  ],
  caption: [Distribution per class across dataset splits in Fingernail Images Dataset],
)<class-distribution>

The class with the highest representation across all sets is Terry's Nail, while Muehrcke’s Lines is the most underrepresented. Weighted loss was used during training to compensate for class imbalance and improve model fairness across underrepresented classes. To better understand and visualize each nail feature, Table 4 shows the descriptions of the nail features along with sample images.

#pagebreak()
#{
  set image(width: 50%)
  figure(
    table(
      columns: (1.5fr, 3fr, 1.5fr),
      align: (x, y) => if x < 2 and y != 0 { left } else { horizon + center },
      table.header([Class], [Description], [Sample Image]),

      [Beau's Line],
      [Beau’s lines are horizontal ridges or dents in one or more of the fingernails or toenails.],
      [#image("img/table-2-beaus-line.jpg")],
      //https://my.clevelandclinic.org/health/symptoms/22906-beaus-lines

      [Blue Finger],
      [Also known as Blue Nails, is when the nails turn a bluish tone.],
      [#image("img/table-2-blue-finger.jpg")],

      [Clubbing],
      [Nails appear wider, spongelike, or swollen, like an upside-down spoon.],
      [#image("img/table-2-clubbing.jpg")],

      [Healthy Nail],
      [Healthy nails are smooth, consistent in color and consistency.],
      [#image("img/table-2-healthy.jpg")],

      [Koilonychia], [Soft nails that have a spoon-shaped dent.], [#image("img/table-2-koilonychia.jpg")],

      [Melanonychia],
      [Brown or black discoloration of a nail. It may be diffuse or take the form of a longitudinal band.],
      [#image("img/table-2-melanonychia.jpg")],

      //https://dermnetnz.org/topics/melanonychia
      [Muehrcke’s Lines], [Horizontal white lines across the nail.], [#image("img/table-2-muehrckes-lines.jpg")],

      //https://my.clevelandclinic.org/health/symptoms/muehrcke-lines
      [Onychogryphosis],
      [Characterized by an opaque, yellow-brown thickening of the nail plate with elongation and increased curvature.],
      [#image("img/table-2-onychogryphosis.jpg")],
      //https://dermnetnz.org/topics/onychogryphosis
      [Pitting],
      [May show up as shallow or deep holes in the nail. It can look like white spots or marks.],
      [#image("img/table-2-pitting.jpg")],

      [Terry's Nail],
      [The nail looks white, like frosted glass, except for a thin brown or pink strip at the tip. The lunula is obliterated.],
      [#image("img/table-2-terrys-nail.jpg")],
      //https://my.clevelandclinic.org/health/symptoms/22890-terrys-nails
    ),
    caption: [Description of Nail Features],
  )
}

The dataset we collected was already pre-processed and augmented. These were the preprocessing step used by the owner of the public dataset:
- Automatic orientation correction (EXIF metadata removed)
- Resizing to $416 times 416$ pixels using "fit" scaling, which introduces black padding to maintain aspect ratio

To improve model generalization, data augmentation was also applied, producing three versions of each source image. These augmentations included:
- 50% chance of horizontal flip
- 50% chance of vertical flip
- Equal probability of a 90-degree rotation (none, clockwise, counter-clockwise, or 180°)
- Random rotation within the range of -15° to +15°
- Random shear transformations between -15° and +15° in both horizontal and vertical directions
- Random brightness adjustment between -20% and +20%
- Random exposure adjustment between -15% and +15%

A sample of nail augmentations can be seen on the table below, which shows sample images of the nail features.

#{
  set image(width: 50%)
  figure(
    table(
      columns: (1fr, 0.3fr),
      align: (x, y) => if x < 0 { left } else { horizon + center },
      table.header([Class], [Sample Image]),
      [Beau's Line], [#image("img/augmentation-beaus-line.jpg")],
      [Blue Finger], [#image("img/augmentation-blue-finger.jpg")],
      [Clubbing], [#image("img/augmentation-clubbing.jpg")],
      [Healthy Nail], [#image("img/augmentation-healthy.jpg")],
      [Koilonychia], [#image("img/augmentation-koilonychia.jpg")],
      [Melanonychia], [#image("img/augmentation-melanonychia.jpg")],
      [Muehrcke’s Lines], [#image("img/augmentation-muehrckes-lines.jpg")],
      [Onychogryphosis], [#image("img/augmentation-onychogryphosis.jpg")],
      [Pitting], [#image("img/augmentation-pitting.jpg")],
      [Terry’s Nails], [#image("img/augmentation-terrys-nails.jpg")],
    ),
    caption: [Sample Nail Augmentations],
  )
}

Preprocessing and augmentation were already done through the Roboflow repository, but the researchers had to do more to get the images ready for PyTorch. Everything was resized to $224 × 224$ pixels, which is what most pretrained CNNs take as input.

Each image was then converted into a tensor. Normalization followed — using ImageNet's standard mean and standard deviation, since the pretrained models in PyTorch were originally trained with those values. That alignment keeps the input distribution consistent, which helps the model converge more reliably.

The dataset would not have worked with the chosen architectures without these additional steps.

==== Statistical Dataset
The researchers also put together a separate statistical dataset by hand. This one supports the Bayesian inference side of the pipeline — linking detected nail features to possible underlying diseases. The data came from peer-reviewed literature, scientific journals, public health databases, and other reliable statistical sources, with a focus on probabilities and demographics relevant to the Philippine population where that data existed. Searches were done across PubMed Central, Lippincott Williams & Wilkins journals, Statista, Wikipedia for demographic context, and medical sites like Capitol Medical Center and HERDIN. Every entry was cross-checked, and only data from credible, properly cited sources made it in.

The dataset is stored as a CSV file. Each row represents one nail feature–disease association. The columns cover `Nail Feature`, `Associated Disease/Condition`, `P(Nail|Disease)` (how likely the nail feature is given the disease), `P(Disease)` (prior probability), `P(Disease) Population` (population-specific prevalence), `P(Disease) Sex_Female` and `P(Disease) Sex_Male` for sex-specific rates, `Age (Mean)`, `Age_Low`, `Age_High` for demographics, and source citations with hyperlinks for transparency.

There are 31 associations across all 10 nail features — matching the image dataset classes — connecting them to conditions like COVID-19, chemotherapy side effects, gastrointestinal diseases, renal failure, anemia, and heart disease, among others. The probabilities came from epidemiological studies, clinical reports, and registries like GLOBOCAN, adjusted for Philippine data where possible. No primary data was collected. Everything is a literature-based estimate, built to feed into posterior probability calculations in the Bayesian framework. @stat-sample-dataset shows a sample of how the data is distributed across classes.

#figure(
  table(
    columns: (1fr, 2fr, 1fr),
    align: (x, y) => if x < 2 and y != 0 { left } else { horizon + center },
    table.header([Nail Feature], [Associated Diseases/Condition (Examples)], [No. of Associations]),

    [Beau's Line],
    [COVID-19, Chemotherapy, Gastrointestinal and Liver System Disease, Renal System Disease, Hematopoietic System Disease, Chronic Renal Failure],
    [6],

    [Blue Finger], [Raynaud's Phenomenon, Congenital Heart Disease], [2],

    [Clubbing],
    [Lung Cancer, Crohn's Disease, Ulcerative Colitis, Cardiovascular System Disease, Gastrointestinal and Liver System Disease, Renal System Disease, Hematopoietic System Disease, Chronic Renal Failure],
    [8],

    [Healthy Nail], [No Systemic Disease], [1],

    [Koilonychia], [Iron Deficiency Anemia, Hematopoietic System Disease], [2],

    [Melanonychia], [Subungual Melanoma, Human Immunodeficiency Virus (HIV), Chronic Renal Failure], [3],

    [Muehrcke’s Lines], [Nephrotic Syndrome, Chronic Renal Failure, Renal System Disease], [3],

    [Onychogryphosis], [Chronic Renal Failure, Elderly Population], [2],

    [Pitting], [Psoriasis, Alopecia Areata], [2],

    [Terry’s Nail], [Liver Cirrhosis, Congestive Heart Failure], [2],
  ),
  caption: [Distribution per class across dataset splits in Statistical Dataset],
) <stat-sample-dataset>

@sample-feature-stat showcases how the dataset can be used to compute likelihoods, such as the conditional probability of observing a specific nail feature given a disease, combined with disease priors for posterior estimations.

#figure(
  table(
    columns: (1fr, 1fr),
    align: (x, y) => if x == 0 { left } else { center },
    table.header([Feature], [Sample Value]),
    [Nail feature], [Terry’s Nails],
    [Associated Disease/Condition], [Congestive heart failure],
    [P(Nail | Disease)], [0.306],
    [P(Disease)], [0.016],
    [P(Disease) Population], [92337852],
    [P(Disease) Sex_Female], [0.501],
    [P(Disease) Sex_Male], [0.499],
    [Age (Mean)], [52.6],
    [Age_Low], [19],
    [Age_High], [114],
  ),
  caption: [Sample of Features and Values from Statistical Dataset],
) <sample-feature-stat>

=== Data Model Generation
This section describes the framework behind the deep learning model — covering nail disease classification and probabilistic inference of systemic conditions. The workflow sticks to standard machine learning methodology, drawing from CRISP-DM and similar pipelines. Reproducibility, scalability, and clinical relevance were central to every decision. On the engineering side, the researchers leaned on modular design, OOP, and the DRY principle as described by @hunt_pragmatic_1999 in The Pragmatic Programmer. That made it practical to run multiple experiments across different models without writing redundant code.

==== Data Loading and Preprocessing
#set image(width: 100%)

#figure(
  image("./img/system-archi-model-section1.png"),
  caption: [Data Loading and Preprocessing Workflow],
) <data-loading-and-prep>

@data-loading-and-prep outlines the first step. The project repository gets cloned into Google Colab, which provides GPU-accelerated compute. The dataset comes from a version-controlled GitHub repository — keeping data handling reproducible across experiments. From there, the Data Loader pulls in the images and divides them into training, validation, and test subsets. That split follows standard practice: no data leakage, and evaluation stays unbiased.

The Data Loader preprocesses everything too. Images are resized to 224×224 pixels, the input size models like VGG, ResNet, EfficientNet, ConvNeXt-Tiny, and SwinV2-T were designed around. Other resolutions would technically work, but 224×224 matches the ImageNet setup and plays best with pretrained weights. After that, images become tensors for PyTorch and get normalized with ImageNet statistics to keep the data distribution aligned with what the pretrained models expect. Augmentation rounds it out — random flips, rotations, brightness shifts — mimicking real-world variation in nail images so the model generalizes better. The preprocessed data then goes back into Colab, ready for training.

==== Model Training
#figure(
  image("./img/system-archi-model-section2.png"),
  caption: [Model Training Workflow],
)

Training comes next. The model has to learn to pick up on nail biomarkers, which means the training engine, model, loss function, optimizer, and scheduler all need to work together. One of the pretrained architectures gets loaded — VGG-16, ResNet-50, EfficientNetV2-S, SwinV2-T, or ConvNeXt-Tiny — and transfer learning carries over visual features from ImageNet. Less training data needed, faster convergence. Medical imaging research has consistently backed this approach.

Class imbalance gets addressed through Weighted Cross-Entropy loss, which increases the gradient contribution from underrepresented classes. AdamW runs the optimization at 1×10⁻⁴, pairing adaptive moment estimation with decoupled weight decay. ReduceLROnPlateau watches validation performance and drops the learning rate when it flatlines. Each epoch does the standard loop: forward propagation, loss computation, backpropagation. Training continues until convergence or until early stopping cuts it off.

==== Model Training
#figure(
  image("./img/system-archi-model-section2.png"),
  caption: [Model Training Workflow],
)

==== Model Validation and Evaluation
#figure(
  image("./img/system-archi-model-section3.png"),
  caption: [Model Validation and Performance Monitoring Workflow],
)
After each epoch, the validation engine runs the model on held-out data without updating any weights — just measuring how it performs. The Metrics Calculator computes validation loss and accuracy, and those numbers get fed back as a signal for what happens next.

Two things can happen from there. If the validation results are the best seen so far, the system saves the model as a checkpoint — that way the best version is always preserved. If results stop improving, early stopping checks whether training should end. Depending on where things stand, it either reduces the learning rate or stops training entirely to save time and avoid overfitting. Once training wraps up, the model is evaluated using accuracy, precision, recall, F1 score, confusion matrix, and the training and validation loss and accuracy curves.

The end result is that only the best-performing model gets kept. The whole process runs automatically — validation, checkpointing, early stopping — so the model that comes out the other end is as accurate and generalizable as it can be before deployment.

==== Systemic Disease Inference
After evaluating the trained CNN and ViT models on the test set — checking how accurately they detect features like pitting, clubbing, or healthy nails — the system moves to disease inference. The detection outputs feed into a Bayesian framework that estimates the probability of underlying systemic diseases given the observed nail features. Raw confidence scores from the model are calibrated through the confusion matrix first, which corrects for overconfidence and brings the scores closer to what the model actually gets right in practice.

#figure(
  image("./img/systemic-disease-archi.png"),
  caption: [Disease Probability Computation Workflow],
) <systemic-disease-archi>

@systemic-disease-archi lays out the final phase. The model produces confidence scores for detected nail features, and those scores pass through confusion matrix calibration — matching the output probabilities to empirical distributions from validation. From there, the system pulls conditional probabilities $P("Nail" | "Disease")$ and priors $P("Disease")$ out of the statistical dataset CSV. Bayes' theorem does the rest, computing posterior probabilities $P("Disease" | "Nail")$ that fold together the model's evidence with known statistical relationships.

Demographics play a role too. The system adjusts disease priors based on the user's age and sex to reflect population-level differences in prevalence. After adjustment, probabilities get normalized and ranked — so you might see something like Psoriasis at 91.24% and Alopecia Areata at 7.29%. It combines data-driven feature recognition with probabilistic reasoning, producing results that are both interpretable and clinically useful. The Bayesian layer adds transparency that a standalone neural network would not provide.

The pipeline was designed to be modular. It handles whatever confidence scores come in from the model, no matter which nail image is being processed. Prior knowledge from the curated feature–disease dataset feeds in, demographics refine the priors, and post-hoc calibration accounts for systematic misclassifications. No features are hardcoded — the system generalizes across all nail classes.

===== Data Preparation for Inference
Disease inference starts with a CSV file — "StatisticalDataset.csv" — that links nail features to diseases. The file has columns for `Nail Feature` (things like "Pitting" or "Clubbing"), `Associated Disease/Condition` (like "Psoriasis" or "Lung Cancer"), and conditional probabilities `P(Nail|Disease)` on a 0–1 scale showing how likely a nail feature is to show up given a particular disease. Prior probabilities `P(Disease)` sit alongside those, representing how common a disease is in the general population. There are also demographic columns — `P(Disease|Sex_Female)` and `P(Disease|Sex_Male)` — and age-related parameters covering mean, low, and high ranges. That covers the core structure.

A Python script loads this CSV into a Pandas DataFrame. Missing values get filled using Pandas' `fillna` method so nothing breaks downstream. From there, a dictionary called `feature_to_disease` gets built using `defaultdict` out of the `collections` module, and it groups diseases under each nail feature for fast lookup. Each dictionary entry holds the disease name, $P("Nail" | "Disease")$, $P("Disease")$, sex-specific priors, and the age bounds. "Healthy Nail" is a special case — when it maps to "No systemic disease," the system assigns a default prior of 1.0 to represent the baseline where no pathology is present. Any entries with invalid or zero probabilities just get skipped entirely. That avoids division errors and keeps the computation clean.

#figure(
  ```python
  def load_statistical_data(self):
      """Load the statistical dataset from CSV"""
      df = pd.read_csv("data/StatisticalDataset.csv")
      df = df.fillna(value=pd.NA)

      self.feature_to_diseases = defaultdict(list)
      for _, row in df.iterrows():
          f = row['Nail Feature']
          d = row['Associated Disease/Condition']
          p_fd = row['P(Nail | Disease) 0-1%']
          p_d = row['P(Disease) 0-1%']

          if pd.isna(p_d):
              if d == 'No systemic disease':
                  p_d = 1.0
              else:
                  continue

          self.feature_to_diseases[f].append({
              'disease': d,
              'p_fd': p_fd,
              'p_d': p_d,
              'p_female': row['P(Disease) Sex_Female 0-1'],
              'p_male': row['P(Disease) Sex_Male 0-1'],
              'age_low': row['Age_Low'],
              'age_high': row['Age_High'],
              'age_mean': row['Age (Mean)']
          })
      ...
  ```,
  caption: [Loading and Parsing the Inference Dataset],
)

This preparation setup ensures the data is readily accessible for Bayesian updates, deriving implicit $P("Nail")$ via the law of total probability if needed, though the core computation focuses on posterior $P("Disease" | "Nail")$ using Bayes’ theorem: $P("Disease" | "Nail") = (P("Nail" | "Disease") dot P("Disease")) / P("Nail")$. To make the system dynamic, no assumptions were made about specific features; the pipeline processes all detected features with non-zero confidence from the CNN after calibration.

===== Confusion Matrix Calibration
Raw confidence scores from the CNN can carry biases — overconfidence in certain features, or the model mixing up similar classes like pitting and koilonychia. A calibration step corrects for this using the confusion matrix from the test set evaluation. The confusion matrix is a $10 times 10$ array that lines up with the 10 nail feature classes, and it records how often true labels match up against predicted labels. Rows get normalized so each entry becomes a conditional probability $P("Predicted" | "True")$.

The confusion matrix comes straight from the model's evaluation results. Rows are true labels, columns are predicted labels, and the ordering stays consistent with the feature label list — Melanonychia first, Terry's Nails last. Normalizing the rows gives the confusion probability matrix (`conf`). The CNN's raw confidences get assembled into a predicted probability vector `q`, following that same label order, and then the system estimates the true feature probabilities `p` by applying the pseudoinverse of the confusion matrix: `p = pinv(conf) @ q`. Any negative values in `p` get clipped to zero. The vector is then renormalized to sum to 1 so the output stays a valid probability distribution.

What this does, at least in practice, is compensate for the model's systematic error patterns. Say the model keeps confusing clubbing with healthy nails — the adjusted probabilities shift confidence away from that misclassification and redistribute it more accurately. The adjusted_confidence dictionary then replaces the raw scores in all the Bayesian computations that follow, which makes the disease inference more reliable. And the confusion matrix itself can be swapped out whenever the model gets retrained, so the calibration stays current.

#figure(
  ```python
  def load_confusion_matrix(self, model_name):
    """Load confusion matrix for the specified model"""
    metrics_path = Path(__file__).parent.parent.parent / "models" / "metrics" / f"{model_name}_metrics.json"
    with open(metrics_path, 'r') as f:
      metrics = json.load(f)
      confusion_matrix = np.array(metrics['ml_metrics']['confusion_matrix'])
      return confusion_matrix

  def adjust_confidence_with_confusion_matrix(self, confidence_dict, model_name):
    """Adjust confidence scores using confusion matrix (Bayesian calibration)"""
    counts = self.load_confusion_matrix(model_name)
    row_sums = counts.sum(axis=1, keepdims=True)
    conf = counts / row_sums  # Normalize rows to P(pred | true)

    q = np.array([confidence_dict.get(label, 0.0) for label in self.labels])
    adjusted_p = pinv(conf) @ q
    adjusted_p = np.maximum(adjusted_p, 0.0)
    if adjusted_p.sum() > 0:
      adjusted_p /= adjusted_p.sum()

      adjusted_confidence = {self.labels[i]: adjusted_p[i] for i in range(len(self.labels))}
      return adjusted_confidence
  ...
  ```,
  caption: [Confusion Matrix Normalization and Pseudoinverse Calibration],
)

===== Bayesian Inference Setup
The inference uses a naive Bayesian framework. It assumes conditional independence among nail features — a simplification, but a practical one — and weights each feature's contribution by its calibrated confidence score, normalized to a 0–1 probability. These adjusted scores are more trustworthy than the raw outputs. Pitting, for instance, might shift from 0.9962 after the confusion matrix corrections kick in. The system computes unnormalized posteriors for every disease tied to detected features, then normalizes across all of them to get a proper probability distribution.

For any nail feature where the adjusted confidence (`p_f_image`) is above zero, the script loops through linked diseases and calculates an effective prior that factors in demographics. Sex-specific adjustments pull from $P("Disease" | "Sex")$ when available. If the male and female priors sum close to 1, the system treats them as conditional probabilities and multiplies by the base $P("Disease")$. Otherwise they get used as absolute priors directly. Age filtering is blunter — it applies a uniform density within the specified range (so `p_age_d = 1 / (high - low)` if the user's age falls inside), and anything outside that range just gets zeroed out. A disease mismatched to the user's age effectively drops from consideration.

The unnormalized posterior for a disease `d` given feature `f` comes out to `p_fd * effective_prior`. These get summed across diseases and normalized into `p_d_f`, then weighted by `p_f_image` and aggregated across all features. Multiple features can contribute evidence proportionally this way. One final normalization pass makes sure the posteriors sum to 1, and the output is a ranked list of diseases with their probabilities.

#figure(
  ```python
  def compute_disease_probabilities(self, adjusted_confidence, user_sex, user_age):
    """Compute disease probabilities using Bayesian inference"""
    disease_to_post = defaultdict(float)
    sex = user_sex.lower() if user_sex else 'male'
    age = float(user_age) if user_age else 30.0

    for f, entries in self.feature_to_diseases.items():
      p_f_image = adjusted_confidence.get(f, 0)
      if p_f_image == 0:
        continue

        unnorm = {}
        sum_unnorm = 0.0
        for entry in entries:
          d = entry['disease']
          p_fd = entry['p_fd']
          p_d = entry['p_d']
          if pd.isna(p_fd) or p_fd == 0:
            continue

            # Sex-based prior adjustment
            p_female, p_male = entry['p_female'], entry['p_male']
            if p_female is None and p_male is None:
              effective_p_d = p_d
              else:
              p_sex = p_female if sex == 'female' else p_male
              if p_female and p_male and abs((p_female + p_male) - 1) < 0.05:
                effective_p_d = p_d * p_sex
                else:
                effective_p_d = p_sex or p_d
                ...
  ```,
  caption: [Bayesian Posterior Computation with Calibrated Inputs],
)

===== Demographic Integration and User Prompting
The system prompts the user for sex (male or female) and age through simple input functions. It assumes adult users unless told otherwise. These inputs adjust the disease priors — so a disease like Congenital Heart Disease with an age range of 0–0, meaning neonatal onset, would have its `p_age_d` set to zero for an adult user. That disease just drops out. The same logic keeps elderly-specific conditions from showing up for younger users. When demographic data is missing or the dataset has no sex priors for a particular disease, the base $P("Disease")$ carries through unchanged.

The prompting happens after the CNN evaluation finishes but before inference runs, and it stays minimal on purpose. Edge cases come up — non-binary sex, ages that do not make sense — and the system handles those by falling back to unadjusted priors. More inclusive demographic options could be added in future versions.

===== Inference Execution and Dynamic Handling
The script runs inference on the calibrated confidence dictionary, which gets populated dynamically from model outputs rather than being hardcoded. Users can swap in different raw confidence values when testing different nail images, and calibration applies automatically on top. A high raw pitting score might get pulled down if the confusion matrix shows frequent false positives for that class. Clubbing could get boosted if the model tends to underpredict it. The adjusted probabilities are what keep the system from treating a raw 0.0028 for healthy nails the same way it would treat a 0.99 for pitting — post-calibration, each score reflects what the model actually gets right.

The computation skips direct $P("Nail")$ derivation when it can, working with proportional posteriors instead to avoid marginalizing over every disease. That matters for speed. Posteriors get stored in a `defaultdict`, sorted in descending order, and printed in a readable format — diseases listed with their percentages, like Psoriasis at 91.24%.

#figure(
  ```python
    ...
        # Age-based adjustment
        low, high = entry['age_low'], entry['age_high']
        if low and high and low <= age <= high:
          p_age_d = 1.0 / (high - low)
        else:
          p_age_d = 0.0

        unnorm[d] = p_fd * effective_p_d * p_age_d
        sum_unnorm += unnorm[d]

    # Normalize within feature and accumulate contribution
    if sum_unnorm > 0:
      for d, u in unnorm.items():
        p_d_f = u / sum_unnorm
        disease_to_post[d] += p_d_f * p_f_image

# Final normalization across diseases
total_post = sum(disease_to_post.values())
if total_post > 0:
  for d in disease_to_post:
    disease_to_post[d] /= total_post
...
  ```,
  caption: [Core Inference Loop and Normalization with Calibrated Confidence]
)

===== Output Generation and Interpretation
The final output reads like a clinical report — "Potential Systemic Diseases (Probabilities)" at the top, followed by a sorted list. Psoriasis at 91.24%, Alopecia areata at 7.29%, and so on. The framing is deliberate. Results show up as hypotheses, not diagnoses, so users are pushed toward medical follow-up rather than self-diagnosis. When healthy nails come through with high confidence, "No systemic disease" sits at the top of the list. That part is straightforward.

When multiple features come back with high confidence, the aggregation balances evidence across them. Low-confidence scans spread the posteriors out more — no single disease dominates. The calibration step tightens things up further by correcting for where the model tends to get it wrong, and the outputs end up more robust because of it. The whole system is general enough to support iterative testing: upload a new nail image, run it through the CNN, calibrate the confidences, pass them to inference, read the results. Then do it again with a different image.

#figure(
  ```
  Enter your sex (male/female): male
  Enter your age: 21
  Potential Systemic Diseases (probabilities):
  Psoriasis: 55.38%
  Alopecia areata: 44.31%
  No systemic disease: 0.25%
  Raynaud's phenomenon: 0.03%
  Chemotherapy: 0.01%
  Hematopoietic System Disease: 0.01%
  Human Immunodeficiency Virus (HIV): 0.01%
  COVID-19: 0.00%
  Gastrointestinal and Liver System Disease: 0.00%
  Chronic Renal Failure: 0.00%
  Subungual melanoma: 0.00%
  ```,
  caption: [Sample Output for High Pitting Confidence Post-Calibration],
)

This inference module is the last piece of the pipeline. It takes raw nail images and turns them into health insights through calibrated probabilistic reasoning, all in Python.

=== System Development Methodology
#set image(width: 80%)

Kanban was the framework the researchers went with — it is the most stripped-down version of Agile out there. The method has roots in lean manufacturing, and as @the_pm_professional_kanban_2024 describes it, the core of Kanban is a board. Tasks get turned into cards, each card sits in a stage, and the whole team can see what is happening at any point. The real constraint is limiting work-in-progress. You finish what is already on the board before pulling in something new. That keeps bottlenecks from forming.

#figure(
  image("./img/Abstract_Kanban_Board.jpg"),
  caption: flex-caption(
    [Representation of a Kanban Board #cite(<falco_english_2023>, form: "normal")],
    [Representation of a Kanban Board],
  ),
)

A software development company that switched to Kanban found their delays dropped and productivity went up, largely because making the workflow visible forced the team to stop overloading themselves #cite(<fastercapital_kanban_2025>, form: "normal"). Another company — a software services firm — had a similar result, managing to increase throughput while still responding quickly when client priorities changed #cite(<kanban_university_visotech_2024>, form: "normal"). For this study, the researchers chose Kanban because it handled shifting requirements well. The visual board kept everyone aligned, and the WIP limits meant work actually got finished instead of just started.

=== Software Tools Used
Five categories of tools went into building this system: development environments and languages, libraries and frameworks and databases, platforms and version control, AI-assisted development, and documentation and communication. What follows is a breakdown of each.

==== Development Environments and Languages
===== Python
Python served as the primary language across the entire study. The researchers used it for the AI models and the web application both, pulling in PyTorch on the deep learning side and Flask for the web layer. Its readability and the size of its ecosystem are a big part of why it gets picked so often for machine learning and data analysis work.

===== Visual Studio Code
The researchers did most of their development in VS Code. It supports multiple languages, has built-in tooling for HTML, CSS, and JavaScript, and the extension ecosystem fills in whatever gaps come up. The integrated terminal meant they could run commands and handle version control without switching windows. It covered model development and the website work.

===== Google Colaboratory
Colab is a browser-based environment from Google for writing and running Python. The free GPU and TPU access is what makes it popular for machine learning — training models locally would have been slower and more expensive. The researchers ran their training and testing there. Sharing notebooks between collaborators was easy, which helped too.

==== Libraries, Frameworks, and Databases
===== Pytorch
PyTorch handled the deep learning side of the project. It is open-source, supports GPU-accelerated tensor computation, and has automatic differentiation built in for backpropagation. The modular neural network components meant the researchers could assemble their model architecture without starting from zero. Training loops and evaluation experiments ran more efficiently because of it.

===== Matplotlib
The researchers used Matplotlib to visualize data throughout the study — during Exploratory Data Analysis to find patterns and distributions in the dataset, and later during model evaluation. It generates plots, charts, and graphs. The visualizations helped make sense of what the raw numbers were actually showing.

===== Flask
Flask is a Python web framework. Lightweight. The researchers used it to build the web application and handle API endpoints. It provides structure for servers, HTTP requests, and route management without requiring much boilerplate code.

===== Bootstrap
The website's front-end was built using Bootstrap, a framework that ships with pre-made CSS and JavaScript components for responsive, mobile-first layouts. The grid system and utility classes kept things consistent across pages. Reusable components made the front-end easier to scale and maintain over time.

===== SQLite
SQLite runs as a serverless database embedded directly in the application. The researchers stored user accounts, diagnosis results, and related records in it. Setup is minimal — almost nonexistent, really — but it still supports ACID transactions. Data integrity was not something they had to worry about despite the lightweight footprint.

==== Platforms and Version Control
===== Git
Version control ran through Git for the whole project. Source code, model files, the manuscript — all of it. The researchers tracked changes, created branches for separate tasks, and merged updates back. The Typst files used for writing the paper had version history too, which mattered when multiple people were editing at once.

===== GitHub
The project's code was hosted on GitHub. Researchers pushed commits, pulled updates, worked on parallel branches, and tracked issues there. It served as the central point of collaboration. Everything stayed in one place, which kept the workflow from getting scattered.

===== Hugging Face
The trained models were hosted on Hugging Face. That made version tracking and experiment reproducibility straightforward, and deploying models later became simpler. During testing, the researchers could pull models directly through code from the platform instead of managing files manually.

==== AI-Assisted Development
===== AI Coding Assistants
The researchers used GitHub Copilot inside VS Code as their primary coding assistant. It handled the repetitive stuff — boilerplate for Flask routes, scaffolding PyTorch model classes, data preparation functions. Tedious work, but it adds up. Having the AI take care of that gave the researchers more room to focus on application architecture and the neural network logic, which required actual thought.

===== Conversational Language Models
ChatGPT from OpenAI and Google's Gemini were used as problem-solving tools throughout the project. The researchers turned to them for help with confusing error messages, for refactoring Python code to be cleaner and faster, and for brainstorming improvements to the training pipeline. On the writing side, these models helped draft technical documentation, write function descriptions, and tighten up the research paper — mainly by catching inconsistent terminology and simplifying explanations that had gotten too dense.

==== Documentation and Communication Tools
===== Zotero
Reference management went through Zotero. The researchers collected sources, synced them across devices, and generated formatted bibliographies from it. Straightforward.

===== Google Docs
The manuscript started in Google Docs. Real-time collaboration and change tracking made it easy to get feedback, and having everything stored in one place kept edits from getting lost between team members.

===== Typst
For the final version of the manuscript, the researchers switched to Typst. It is a modern typesetting system that gave them precise control over layout and formatting. The result was a clean, professional-looking document — noticeably better than what a regular word processor would have produced.

===== Discord
Discord filled the gap when in-person meetings were not possible. Voice and video channels handled the real-time discussions, text channels covered everything else — task assignments, progress updates, day-to-day coordination.

=== Corpus Structure
This section presents comprehensive documentation of the two datasets utilized in this study. @image-corpus describes the image dataset, including its source, composition, class structure, and the preprocessing and augmentation procedures applied to prepare the data for model training.

#figure(
  caption: [Image Dataset Corpus Structure and Composition],
  table(
    columns: (1fr, 1.5fr),
    align: left,
    table.header(
      [CATEGORY],
      [DETAILS],
    ),

    [Dataset Source],
    [Publicly available Nail Disease Detection dataset from Roboflow],

[License],
[Creative Commons Attribution 4.0 (CC BY 4.0)],

[Annotation Format],
[TensorFlow TFRecord (Raccoon)],

[Image Format],
[.jpg],

[Original Image Count],
[7,264 images across 11 classes],

[Original Class Names],
[- Acral Lentiginous Melanoma
- Beau's Line
- Blue Finger
- Clubbing
- Healthy Nail
- Koilonychia
- Lindsay’s Nail
- Muehrcke’s Lines
- Onychogryphosis
- Pitting
- Terry’s Nail],

[Dataset Modifications],
[- Removed Lindsay's Nail (insufficient images)
- Renamed "Acral lentiginous melanoma" to"Melanonychia"],

[Final Image Count],
[7,258 images across 10 classes],

[Final Class Names],
[- Beau's Line
- Blue Finger
- Clubbing
- Healthy Nail
- Koilonychia
- Melanonychia
- Muehrcke’s Lines
- Onychogryphosis
- Pitting
- Terry’s Nail],

[Expert Consultation and Verification],
[Dr. Cristine Florentino],

[Training Set],
[6,360 images (88%)],

[Validation Set],
[591 images (8%)],

[Test Set],
[307 images (4%)],

[Class Distribution],
[Natural imbalance across all subsets],

[Most Represented Class],
[Terry's Nail],

[Least Represented Class],
[Muehrcke's Lines],

[Training Set Purpose],
[Model learning],

[Validation Set Purpose],
[Hyperparameter tuning and early stopping],

[Test Set Purpose],
[Final model evaluation],

[Class Imbalance Handling],
[Weighted loss function during training],

[Initial Preprocessing],
[- Automatic orientation correction with EXIF metadata removal
- 416 × 416 pixels using "fit" scaling with black padding to preserve aspect ratio],

[Augmentation Multiplier],
[Three versions per source image],

[Augmentation Techniques ],
[- 50% horizontal flip, 50% vertical flip
- Equal probability 90° rotation (none, clockwise, counter-clockwise, 180°)
- Random rotation (-15° to +15°)
- Random shear (-15° to +15° horizontal and vertical)
- Random brightness (-20% to +20%)
- Random exposure (-15% to +15%)],

[PyTorch Preprocessing],
[- 224 × 224 pixels (standard for pre-trained CNN architectures)
- Conversion to tensor format
- ImageNet dataset mean and standard deviation values],

[Purpose of Additional Preprocessing],
[Compatibility with PyTorch framework, stable model convergence, consistency with pre-trained models],

  )
) <image-corpus>

@stat-corpus presents the statistical dataset of systemic diseases associated with nail abnormalities, curated through systematic review of medical literature, which provides the probabilistic framework for diagnostic inference.
#pagebreak()
#[
#show table.cell: set text(size: 8pt)
#show table.cell: set par(leading: 0.5em, spacing: 0.5em)
#figure(
  caption: [Statistical Dataset Corpus Structure],
  table(
    columns: (1fr, 1.5fr, 1.3fr, 1fr, 2fr),
    align: (_, y) => if y==0 { left + horizon } else { left },
    table.header(
      [NAIL FEATURE],
      [SYSTEMIC DISEASE],
      [ASSOCIATION (%)],
      [REFERENCE],
      [REFERENCE DESCRIPTION],
    ),

    [Beau's Lines],
    [COVID-19],
    [18.6],
    [@grover_nail_2022],
    [Cross-sectional study on nail changes in COVID-19 patients showing Beau's lines in 18.6% of cases, reflecting systemic involvement.],
    [Beau's Lines],
    [Chemotherapy],
    [3.2],
    [@shanmugam_reddy_nail_2017],
    [Prospective cross-sectional study identifying Beau's lines in 3.2% of patients undergoing cancer chemotherapy, often associated with platinum-based agents.],
    [Beau's Lines],
    [Gastrointestinal and Liver System Disease],
    [15.2],
    [@mendagudli_descriptive_2024],
    [Descriptive study of nail changes in systemic diseases reporting Beau's lines in 15.2% of patients with gastrointestinal and liver system involvement.],
    [Beau's Lines],
    [Renal System Disease],
    [9.4],
    [@mendagudli_descriptive_2024],
    [Descriptive study of nail changes in systemic diseases reporting Beau's lines in 9.4% of patients with renal system involvement.],
    [Beau's Lines],
    [Hematopoietic System Disease],
    [12.3],
    [@mendagudli_descriptive_2024],
    [Descriptive study of nail changes in systemic diseases reporting Beau's lines in 12.3% of patients with hematopoietic system involvement.],
    [Beau's Lines],
    [Chronic Renal Failure],
    [35.7],
    [@niema_nail_2019],
    [Study on nail disorders in chronic renal failure patients showing Beau's lines in 35.7% of cases.],
    [Blue Finger (Cyanosis)],
    [Raynaud's phenomenon],
    [11.95],
    [@vizir_executable_2017],
    [Rheumatology guidelines highlighting cyanosis as part of the triphasic color changes in Raynaud's phenomenon, indicating vasospasm and deoxygenation in 11.95% of cases.],
    [Blue Finger (Cyanosis)],
    [Congenital Heart Disease],
    [25],
    [@ossa_galvis_cyanotic_2025],
    [Review on cyanotic heart disease describing cyanosis in 25.0% of congenital heart disease cases due to right-to-left shunting.],
    [Clubbing],
    [Lung cancer],
    [10],
    [@sarkar_digital_2012],
    [Review on digital clubbing noting its occurrence in 10.0% of lung cancer patients as a paraneoplastic manifestation.],
    [Clubbing],
    [Crohn's disease],
    [38],
    [@kitis_finger_1979],
    [Study on finger clubbing in inflammatory bowel disease reporting prevalence of 38.0% in Crohn's disease patients.],
    [Clubbing],
    [Ulcerative colitis],
    [15],
    [@kitis_finger_1979],
    [Study on finger clubbing in inflammatory bowel disease reporting prevalence of 15.0% in ulcerative colitis patients.],
    [Clubbing],
    [Cardiovascular System Disease],
    [43.8],
    [@mendagudli_descriptive_2024],
    [Descriptive study of nail changes in systemic diseases reporting clubbing in 43.8% of patients with cardiovascular system involvement.],
    [Clubbing],
    [Gastrointestinal and Liver System Disease],
    [28.3],
    [@mendagudli_descriptive_2024],
    [Descriptive study of nail changes in systemic diseases reporting clubbing in 28.3% of patients with gastrointestinal and liver system involvement.],
    [Clubbing],
    [Renal System Disease],
    [12.5],
    [@mendagudli_descriptive_2024],
    [Descriptive study of nail changes in systemic diseases reporting clubbing in 12.5% of patients with renal system involvement.],
    [Clubbing],
    [Hematopoietic System Disease],
    [3.5],
    [@mendagudli_descriptive_2024],
    [Descriptive study of nail changes in systemic diseases reporting clubbing in 3.5% of patients with hematopoietic system involvement.],
    [Clubbing],
    [Chronic Renal Failure],
    [1.8],
    [niema_nail_2019],
    [Study on nail disorders in chronic renal failure patients showing clubbing in 1.8% of cases.],
    [Koilonychia],
    [Iron Deficiency Anemia],
    [5],
    [@walker_koilonychia_2016],
    [Update on koilonychia pathophysiology reporting its presence in 5.0% of iron deficiency anemia cases.],
    [Koilonychia],
    [Hematopoietic System Disease],
    [21.1],
    [@mendagudli_descriptive_2024],
    [Descriptive study of nail changes in systemic diseases reporting koilonychia in 21.1% of patients with hematopoietic system involvement.],
    [Melanonychia],
    [Subungual melanoma],
    [30],
    [Longitudinal Melanonychia Review],
    [Review on distinguishing malignant from benign melanonychia noting association in 30.0% of subungual melanoma cases.],
    [Melanonychia],
    [Human Immunodeficiency Virus (HIV)],
    [25.3],
    [@flores-bozo_nail_2022],
    [Observational study on nail changes in HIV patients showing melanonychia in 25.3% of cases.],
    [Melanonychia],
    [Chronic Renal Failure],
    [14.2],
    [@niema_nail_2019],
    [Study on nail disorders in chronic renal failure patients showing melanonychia in 14.2% of cases.],
    [Muehrcke’s Lines],
    [Nephrotic syndrome],
    [23],
    [@schwartz_muehrcke_2024],
    [Overview on Muehrcke lines reporting their presence in 23.0% of nephrotic syndrome cases linked to hypoalbuminemia.],
    [Muehrcke’s Lines],
    [Chronic Renal Failure],
    [7.1],
    [@niema_nail_2019],
    [Study on nail disorders in chronic renal failure patients showing Muehrcke’s lines in 7.1% of cases.],
    [Muehrcke’s Lines],
    [Renal System Disease],
    [9.4],
    [@mendagudli_descriptive_2024],
    [Descriptive study of nail changes in systemic diseases reporting Muehrcke’s lines in 9.4% of patients with renal system involvement.],
    [Onychogryphosis],
    [Chronic Renal Failure],
    [10.7],
    [@niema_nail_2019],
    [Study on nail disorders in chronic renal failure patients showing onychogryphosis in 10.7% of cases.],
    [Onychogryphosis],
    [Elderly Population],
    [11.2],
    [@ko_onychogryphosis_2018],
    [Case report and review reporting onychogryphosis prevalence of 11.2% in the elderly population.],
    [Pitting],
    [Psoriasis],
    [45],
    [@schons_nail_2014],
    [Review of nail psoriasis literature highlighting pitting as a common feature in 45.0% of psoriasis cases.],
    [Pitting],
    [Alopecia areata],
    [80],
    [@shakoei_clinical_2024],
    [Cross-sectional study on nail involvement in alopecia areata reporting pitting in 80.0% of severe cases.],
    [Terry’s Nails],
    [Liver cirrhosis],
    [25.6],
    [@sack_association_2021],
    [Prospective study showing association of Terry’s nails with liver cirrhosis in 25.6% of cases.],
    [Terry’s Nails],
    [Congestive heart failure],
    [30.6],
    [LITFL: Terry's Nails, 2023],
    [Medical education resource associating Terry’s nails with chronic congestive heart failure in approximately 30.6% of cases.],
  )
) <stat-corpus>]

=== Software Testing
The researchers ran a structured testing phase to see how well the fingernail biomarker screening system actually performed. The goal was to check whether the system does what it is supposed to do — classify nail features using deep learning and infer associated systemic diseases through probabilistic reasoning — while keeping the outputs clinically plausible, interpretable, and responsible. Not a diagnostic tool. A screening tool.

Testing looked at the system from two angles: technical performance and expert judgement. The researchers wanted to know if nail feature classification was accurate, if the Bayesian disease associations made sense, and if the system worked as a non-invasive decision-support tool. The evaluation instruments were built for expert assessment, and they stayed within the study's stated scope — the system is not meant to give definitive medical diagnoses, and the testing reflected that.

Domain-knowledgeable evaluators assessed the system's outputs using structured rating scales. The instruments measured more than just correctness. They also looked at how the system handles uncertainty and whether it avoids making absolute diagnostic claims — responsible AI behavior, in other words. The testing phase was designed to confirm that the system's performance lines up with what would be realistic in a preventive healthcare context, not that it replaces clinical expertise.

==== Actual Testing Using Expert Evaluation
The researchers used a feedback questionnaire to evaluate the system's classification reliability and the quality of its probabilistic inferences. For AI-based healthcare systems, this kind of expert-driven assessment makes sense — it lets evaluators bring their domain knowledge and professional judgement to bear when judging whether the outputs are realistic, interpretable, and acceptable.

The questionnaire covered ten core evaluation statements across several dimensions:
  - How accurately the system identifies fingernail features
  - Whether classifications align with dermatological standards
  - Medical plausibility of the associations between nail features and systemic diseases
  - How interpretable and clinically relevant the probability scores are
  - Whether the system handles uncertainty properly in disease risk estimation
  - Ethical considerations around using AI in healthcare
  - Whether the system could realistically be used for screening or clinical support

Evaluators rated the system on each statement using a 3-point ordinal scale — Pass, Fair, or Fail — based on whether the system met expectations for what it was designed to do.

#figure(
  caption: [3-Point Ordinal Rating Scale for System Evaluation],
  table(
    columns: (1fr, 2fr),
    align: left,
    table.header(
      [Rating],
      [Description]
    ),

    [Pass],
    [The system meets expectations; the core function is clearly achieved],

    [Fair],
    [The system partially meets expectations; acceptable but with limitations],

    [Fail],
    [The system does not meet expectations; the core function is not achieved],
  )
)

The scale was chosen because it is concise and easy to interpret, which suits expert evaluation well. "Pass" means the evaluator considers the output accurate, realistic, and acceptable for probabilistic health screening. "Fair" means the system works but has noticeable limitations — it does the job, at least partially, but improvements are needed. "Fail" means the system falls short of its intended function.

The point of this scale is to give a clear read on whether the system meets its objectives without implying it can do more than it actually can. It stays consistent with the study's ethical constraints and does not overstate diagnostic capability.

==== Evaluator Testing Using Sample Nail Images
The researchers prepared ten anonymized fingernail images for this part of the evaluation, one for each nail feature class in the dataset. Each image was run through the system, which produced a detected nail feature and a set of systemic disease probabilities from the Bayesian inference layer.

Evaluators reviewed the detected feature alongside a short description of its visual characteristics, then indicated whether they agreed or disagreed with how the system classified it. The ten nail feature classes tested were:
- Beau's Lines
- Blue Nail (Cyanosis)
- Clubbing
- Healthy Nail
- Koilonychia
- Melanonychia
- Muehrcke's Lines
- Onychogryphosis
- Pitting
- Terry's Nails

This step was a qualitative check on the system's feature recognition. The point was to confirm that what the system detects actually lines up with clinically recognizable visual patterns — not arbitrary labels or misleading outputs. When evaluators agreed with the classification, it meant the system's output matched what someone with domain expertise would expect based on standard dermatological descriptions.

#pagebreak()
#metadata("Chapter 3 end") <ch3-e>

#metadata("Chapter 4 start")<ch4-s>
#chp[Chapter IV]
#h2(outlined: false, bookmarked: true)[Results and Discussion]

=== System Architecture
#set image(width: 100%)

#figure(
  image("./img/system-archi-web.png"),
  caption: [System Architecture Design],
) <system-architecture>

The architecture shown in @system-architecture puts the trained model into a working backend that handles inference requests, database operations, and probabilistic computations in real time. A user uploads a nail image through the web interface, and the API Gateway picks it up as an HTTP POST request. It validates the data, then passes it along to the backend's business logic layer. The image itself gets stored temporarily in a local directory, and its file path and metadata go into an SQLite database — that way there is a record for traceability if something needs to be checked later.

From there, the Machine Learning Inference Service pulls the image and runs classification through the trained deep learning model. The output is a class label and a confidence score. The business logic layer logs that result and queries the database for prior probabilities and likelihood values tied to the detected features, which the Bayesian inference module then uses to compute disease probabilities. Tying database queries directly to the inference step keeps the data consistent and means the system's predictions are grounded in the actual statistical dataset rather than operating in isolation. Results flow back through the API Gateway to the front end, where the user sees the diagnostic outcomes laid out in a readable format.

=== Research Objective 1
To obtain a publicly available fingernail image dataset from Roboflow, consisting of at least 3,000 labeled images across a minimum of 5 distinct nail feature classes, with each image meeting a minimum resolution of 224×224 pixels, the dataset will be verified by a dermatologist. In parallel, to curate a statistical dataset to be used for inference using Bayesian inference, containing percentage-based associations between these nail feature classes and systemic diseases derived from published clinical, epidemiological studies, and literature.

The labeled nail feature dataset came from Roboflow, sourced on April 17, 2024, when it was still publicly available. At some point after that it went private or was taken down — the exact date is unclear, but as of writing it is no longer accessible. All the results in this study are based on the version originally downloaded, and the acquisition details have been documented. Future researchers trying to reproduce this work may run into that availability issue. The dataset itself contains 7,258 images across 10 classes, each at 416×416 resolution, which is compatible with PyTorch's pretrained weights trained on 224×224 pixels. A dermatologist from Laguna Holy Family Hospital, Dra. Cristine Florentino, verified the dataset.

#figure(
  image("./img/dataset-file-structure.png"),
  caption: [Screenshot of the File Structure of the Dataset],
) <file-structure>

@file-structure shows a screenshot of the file structure of the dataset in the researcher’s computer. The top left window is the root of the dataset. It consists of the dataset splits which are the training, validation, and test set. The bottom left window shows the child folders which consist of  each class of the dataset. The right window shows the grandchild folder, which consists of the images of a class.

=== Research Objective 2
To apply standardized preprocessing steps including resizing and normalization to ensure consistency and suitability for deep learning, and to augment the image dataset by at least 30% using systematic geometric and photometric transformations to enhance model generalization and robustness for systemic disease classification.

The dataset from Roboflow came pre-augmented: 50% horizontal flip, 50% vertical flip, equal-probability 90° rotations (none, clockwise, counter-clockwise, and 180°), random rotation between -15° and +15°, random shear (-15° to +15° in both directions), random brightness (-20% to +20%), and random exposure (-15% to +15%). On top of that, the researchers applied their own preprocessing to make it work with PyTorch. Images were resized to 224×224, converted to tensor format, and normalized using the standard ImageNet mean ($[0.485, 0.456, 0.406]$) and standard deviation ($[0.229, 0.224, 0.225]$). That standardization keeps input distributions consistent, which helps with stable gradient flow and makes transfer learning more effective during training.

=== Research Objective 3
To experiment, develop and train multiple deep learning models (EfficientNetV2S, VGG16, ResNet50, RegNetY-16GF, and SwinV2-T) on the dataset to accurately classify nail features and to make systemic diseases inferences using Bayesian inference from the statistical dataset of systemic diseases.

Five deep learning architectures were developed and trained. The original plan included RegNetY-16GF, but during experimentation it was swapped out for ConvNeXt-Tiny — the tradeoff between performance and computational cost was better, and it still kept convolutional inductive biases. The final lineup was VGG-16, ResNet-50, EfficientNetV2-S, SwinV2-T, and ConvNeXt-Tiny. All of them used transfer learning with ImageNet-pretrained weights to speed up convergence and improve accuracy. Training ran with the AdamW optimizer at a learning rate of 1e-4, Weighted Cross-Entropy Loss to handle class imbalance, and a ReduceLROnPlateau scheduler that adjusted learning rates when validation performance stopped improving.

Alongside the image classification work, the researchers built a probabilistic Bayesian inference engine linking nail features to systemic diseases. A statistical dataset was put together from peer-reviewed clinical literature — 31 associations in total, covering conditions like cardiovascular disease, renal failure, and liver cirrhosis, with conditional probabilities (P(Nail∣Disease)) and priors (P(Disease)) for each. The engine computes posterior probabilities of systemic diseases given a detected nail feature and folds in demographic factors like age and sex to adjust the priors. That two-phase setup — visual classification first, then probabilistic risk assessment — is what moves the system from just identifying a nail feature to estimating what it might mean clinically.

=== Research Objective 4
To evaluate and compare the performance of the trained models using standard metrics, including accuracy, precision, recall, and F1 score for convolutional neural networks (CNNs) and apply explainability and interpretability methods for the algorithms.

Model performance was evaluated on a held-out test set of 307 images. The researchers measured Accuracy, Precision, Recall, and F1-Score across all ten nail feature classes. Several training strategies were compared: training from scratch, baseline with frozen weights, full fine-tuning, and gradual unfreezing. Modern architectures got the most out of gradual unfreezing. VGG-16, being older, did better with full fine-tuning instead.

ConvNeXt-Tiny and SwinV2-T came out on top, hitting roughly 88.93% and 88.27% accuracy — well ahead of VGG-16's 74.92%. EfficientNetV2-S landed close behind at 87.95%. To make these models more interpretable, the researchers applied Grad-CAM and saliency maps. These visualization techniques show which regions of the nail plate the model focuses on when it makes a prediction — discoloration, texture changes, that kind of thing. It adds a layer of clinical transparency that a raw confidence score alone would not provide.

==== Strategy Evaluation
===== Scratch
The Scratch strategy used random weights, no pre-trained ImageNet features, nothing borrowed from prior training. It performed the worst out of all configurations, which was expected. It was run mainly as a control to check whether transfer learning was actually necessary for this kind of task. SwinV2-T and VGG-16 barely converged at all, finishing with accuracies of 11.40% and 13.68%. For a 10-class problem, that's close to random guessing. EfficientNetV2-S and ResNet-50 did better, reaching around 51.14% and 50.81%, but those numbers still fell well short of the 80% target the study was aiming for. Training from random weights on roughly 7,000 images wasn't enough for these models to learn useful filters from scratch. These architectures need a lot of data, more than what was available here, and the results make that clear. Transfer learning isn't optional in a setting like this.

#{
show table: set text(9pt)
figure(
  caption: [Scratch Training Results],
  table(
    align: (x, y) => if x == 0 and y >= 0 {left} else {center},
    columns: (1.5fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    table.header(
      [MODEL],
      [VAL. LOSS],
      [EPOCH ],
      [ACCURACY],
      [PRECISION ],
      [RECALL ],
      [F1 ],
    ),
    [VGG-16],
    [2.3000],
    [5],
    [0.1368],
    [0.0137],
    [0.1000],
    [0.0241],
    [ResNet-50],
    [1.5318],
    [24],
    [0.5081],
    [0.5038],
    [0.4893],
    [0.4911],
    [EfficientNetV2-S],
    [1.4900],
    [36],
    [0.5114],
    [0.5079],
    [0.4982],
    [0.4961],
    [SwinV2-T],
    [2.2606],
    [9],
    [0.1140],
    [0.0474],
    [0.1415],
    [0.0622],
    [ConvNeXt-Tiny],
    [1.6520],
    [22],
    [0.4658],
    [0.4655],
    [0.4561],
    [0.4543],
  )
)
}

===== Baseline
The Baseline strategy froze the pre-trained backbone entirely, training only the classification head on top. No changes were made to the feature extractor, it was kept fixed. The point was to see how much of what these models learned from ImageNet would carry over to nail images on its own. SwinV2-T and ConvNeXt-Tiny held up well under these frozen conditions, reaching baseline accuracies of around 72.96% and 71.66%. Their features transferred without much help. VGG-16 and ResNet-50 came in lower, both sitting near 63.84%, which suggests their pre-trained features didn't map as cleanly onto the specifics of nail biomarkers, at least not without some fine-tuning first. Older architectures, it seems, need more nudging to adapt.

#{
show table: set text(9pt)
figure(
  caption: [Baseline Training Results],
  table(
    align: (x, y) => if x == 0 and y >= 0 {left} else {center},
    columns: (1.5fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    table.header(
      [MODEL],
      [VAL. LOSS],
      [EPOCH ],
      [ACCURACY],
      [PRECISION ],
      [RECALL ],
      [F1 ],
    ),
    [VGG-16],
    [1.3456],
    [4],
    [0.6384],
    [0.6593],
    [0.6394],
    [0.6179],
    [ResNet-50],
    [1.1391],
    [17],
    [0.6384],
    [0.6685],
    [0.6469],
    [0.6275],
    [EfficientNetV2-S],
    [1.1672],
    [24],
    [0.6221],
    [0.6222],
    [0.6205],
    [0.6084],
    [SwinV2-T],
    [0.8259],
    [43],
    [0.7296],
    [0.7402],
    [0.7306],
    [0.7181],
    [ConvNeXt-Tiny],
    [0.9034],
    [18],
    [0.7166],
    [0.7354],
    [0.7192],
    [0.7031],
  )
)
}

===== Full Finetune
Full fine-tuning unfroze every layer, letting the whole network adjust its weights to better fit the nail dataset. The gains were clear across all models, bigger than anything seen in the Baseline or Scratch runs. VGG-16 benefited the most. Its accuracy jumped to 74.92%, the best result any strategy produced for that architecture. SwinV2-T reached 89.25%, though that came with trade-offs. Full fine-tuning is more expensive to run and more prone to overfitting than gradual fine-tuning, a fair cost given the results, but not something to overlook.

#{
show table: set text(9pt)
figure(
  caption: [Full Finetune Training Results],
  table(
    align: (x, y) => if x == 0 and y >= 0 {left} else {center},
    columns: (1.5fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    table.header(
      [MODEL],
      [VAL. LOSS],
      [EPOCH ],
      [ACCURACY],
      [PRECISION ],
      [RECALL ],
      [F1 ],
    ),
    [VGG-16],
    [0.9659],
    [4],
    [0.7492],
    [0.7778],
    [0.7266],
    [0.7277],
    [ResNet-50],
    [0.6661],
    [20],
    [0.7948],
    [0.8288],
    [0.7843],
    [0.7823],
    [EfficientNetV2-S],
    [0.4666],
    [10],
    [0.8404],
    [0.8578],
    [0.8341],
    [0.8209],
    [SwinV2-T],
    [0.4313],
    [8],
    [0.8925],
    [0.8944],
    [0.8933],
    [0.8863],
    [ConvNeXt-Tiny],
    [0.4916],
    [18],
    [0.8436],
    [0.8767],
    [0.8366],
    [0.8353],
  )
)
}

===== Gradual Unfreeze
Gradual unfreezing progressively unlocked layers starting from the classification head and moving backward. Trying to keep the lower-level features intact while tweaking the more abstract stuff. For the newer architectures, this approach was the best one. ConvNeXt-Tiny and EfficientNetV2-S hit their peak performances here, 88.93% and 87.95%. VGG-16 really struggled with this approach, though, dropping down to 61.08% accuracy since its architecture is just too simple. It couldn't really benefit from the staggered learning rate schedules that usually help out those complex residual or transformer networks.

#{
show table: set text(9pt)
figure(
  caption: [Gradual Unfreeze Training Results],
  table(
    align: (x, y) => if x == 0 and y >= 0 {left} else {center},
    columns: (1.5fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    table.header(
      [MODEL],
      [VAL. LOSS],
      [EPOCH ],
      [ACCURACY],
      [PRECISION ],
      [RECALL ],
      [F1 ],
    ),
    [VGG-16],
    [1.2344],
    [3],
    [0.6059],
    [0.6273],
    [0.5933],
    [0.5762],
    [ResNet-50],
    [0.7325],
    [10],
    [0.7687],
    [0.7863],
    [0.7753],
    [0.7618],
    [EfficientNetV2-S],
    [0.4522],
    [21],
    [0.8795],
    [0.8887],
    [0.8648],
    [0.8703],
    [SwinV2-T],
    [0.3503],
    [17],
    [0.8827],
    [0.8821],
    [0.8815],
    [0.8802],
    [ConvNeXt-Tiny],
    [0.4701],
    [28],
    [0.8893],
    [0.8888],
    [0.8847],
    [0.8852],
  )
)
}

==== Model Evaluation
#set image(width: 80%)

===== VGG-16
VGG-16 was the oldest model we tested, so it worked as the classic baseline. It peaked at 74.92% accuracy with Full Fine-Tuning, and recall was decent at 77.78%, but it still ended up the weakest overall. It also had the biggest parameter count, so it was the most costly to run, costly to run. The confusion matrix shows it had trouble separating look‑alike classes like Koilonychia and Pitting, and it mixed up Clubbing with Terry’s Nails too. That points back to its shallower feature extraction, which just does not keep up with newer deep models.

#figure(
  caption: "Strategy comparison of VGG16",
  image("./img/comparison_vgg16_all_strategies_plot.png")
) <strategy-compare-vgg>

===== ResNet-50
ResNet‑50 did a clear step up from VGG‑16, topping out at 79.48% accuracy with Full Fine‑Tuning. Residual connections let it go deeper without the vanishing gradient mess, and that gave a fairly balanced 79.48% precision and 82.88% recall. Still, the newer models beat it, EfficientNet, Swin, ConvNeXt, so even if it stays a solid industry standard, those plain residual blocks can miss the tiny texture details in nail biomarkers. It’s reliable, yes, but reliable only goes so far.

#figure(
  caption: "Strategy comparison of ResNet-50",
  image("./img/comparison_resnet50_all_strategies_plot.png")
) <strategy-compare-resnet>

===== EfficientNetV2-S
EfficientNetV2-S came out efficient and strong, hitting its best accuracy at 87.95% with Gradual Unfreezing. It balanced accuracy and cost, using fewer parameters (21.5 million) than ResNet-50 while still doing better, better. Precision was 87.95% and recall 88.87%, so the progressive learning and fused‑MBConv blocks really fit medical image work where tiny, subtle details matter.

#figure(
  caption: "Strategy comparison of EfficientNetV2-S",
  image("./img/comparison_efficientnetv2s_all_strategies_plot.png")
) <strategy-compare-efficientnet>

===== SwinV2-T
SwinV2-T, a vision transformer, landed near the top: about 88.27% with Gradual Unfreezing and up to 89.25% with Full Fine-Tuning. And the shifted-window attention lets it model long-range links, so it captures the global context in nail images and keeps precision, recall, and F1 pretty steady. The trade-off is interpretability, a trade-off again, transformers do not give the straightforward feature maps you get from CNNs.

#figure(
  caption: "Strategy comparison of SwinV2-T",
  image("./img/comparison_swinv2t_all_strategies_plot.png")
) <strategy-compare-swinv2t>

===== ConvNeXt-Tiny
ConvNeXt-Tiny was the best CNN in the run, hitting 88.93% with Gradual Unfreezing and basically matching the Vision Transformer. Modernized ResNet choices came in, bigger kernels, fewer activations, but the CNN bias stayed, and the results were state‑of‑the‑art. Precision peaked at 88.88% and F1 score at 88.52%, the highest of the best variants, so it ended up the most solid for the mix of subtle, varied nail features. And that mix of subtle features mattered.

#figure(
  caption: "Strategy comparison of ConvNeXt-Tiny",
  image("./img/comparison_convnexttiny_all_strategies_plot.png")
) <strategy-compare-convnext>

==== Best Variant per Model
Training strategy results split the older and newer models. The summary table shows VGG‑16 and ResNet‑50 did best with Full Fine‑Tuning, at 74.92% and 79.48% accuracy, because their simpler builds needed a full weight update. The newer group, EfficientNetV2‑S, SwinV2‑T, ConvNeXt‑Tiny, peaked with Gradual Unfreezing, and ConvNeXt‑Tiny had the top accuracy at 88.93%. That pattern says modern models do better when you keep their pre‑trained feature extractors intact, mostly intact, then let them adapt bit by bit to the nail domain.

#{
show table: set text(9pt)
figure(
  caption: [Best variant per model],
  table(
    align: (x, y) => if x == 0 and y >= 0 {left} else {center},
    columns: (1.5fr, 1.5fr, 1fr, 1fr, 1fr, 1fr, .5fr),
    table.header(
      [MODEL],
      [STRATEGY],
      [VAL. LOSS],
      [ACCURACY],
      [PRECISION],
      [RECALL],
      [F1],
    ),
    [VGG-16],
    [Full Finetune],
    [0.9659],
    [0.7492],
    [0.7778],
    [0.7266],
    [0.7277],
    [ResNet-50],
    [Full Finetune],
    [0.6661],
    [0.7948],
    [0.8288],
    [0.7843],
    [0.7823],
    [EfficientNetV2-S],
    [Gradual Unfreeze],
    [0.4522],
    [0.8795],
    [0.8887],
    [0.8648],
    [0.8703],
    [SwinV2-T],
    [Gradual Unfreeze],
    [0.3503],
    [0.8827],
    [0.8821],
    [0.8815],
    [0.8802],
    [ConvNeXt-Tiny],
    [Gradual Unfreeze],
    [0.4701],
    [0.8893],
    [0.8888],
    [0.8847],
    [0.8852],
  )
)
}

#figure(
  caption: "Performance comparison of the best version of each model",
  image("./img/comparison_all_experiments_plot.png")
) <best-model-compare>

===== VGG-16
VGG-16 with Full Fine-Tuning shows the limits on subtle nail cues. The confusion matrix shows many mixups, especially Koilonychia against look‑alike classes. The normalized matrix puts numbers on it: 39.29 percent correct for Koilonychia, 50.00 percent for Muehrcke’s Lines, so texture details are slipping. Per-class metrics back that up, with Onychogryphosis at 97.06 percent while small-detail classes fall behind. The training history still converged, but validation accuracy flattened early near 75 percent, so the model hit its ceiling for this dataset.

#figure(
  caption: "Confusion matrix of VGG-16 (full finetune)",
  image("./img/vgg_confusion_matrix.png")
) <vgg-confusion>

#figure(
  caption: "Normalized confusion matrix of VGG-16 (full finetune)",
  image("./img/vgg_confusion_matrix_normalized.png")
) <vgg-confusion-normalized>

#figure(
  caption: "Per class metrics of VGG-16 (full finetune).",
  image("./img/vgg_per_class_metrics.png")
) <vgg-per_class_metrics>

#figure(
  caption: "Training history of VGG-16 (Full finetune)",
  image("./img/vgg_training_history.png")
) <vgg-training_history>

===== ResNet-50
ResNet-50 under Full Fine-Tuning is better than VGG-16, but the hard classes still bite. The confusion matrix shows fewer false negatives, yet the normalized matrix says Koilonychia is only 32.14 percent correct. It does very well on Pitting at 96.88 percent and Melanonychia at 91.67 percent. Per-class metrics stay fairly balanced, except for the minority classes where features are thinner, thinner. Loss drops steadily, but the train vs validation gap hints at mild overfitting compared to newer models.

#grid(
  columns: (1fr),
  gutter: 2em,
  figure(
    caption: "Confusion matrix of ResNet-50 (full finetune)",
    image("./img/resnet50_confusion_matrix.png"),
  ),

  figure(
    caption: "Normalized confusion matrix of ResNet-50 (full finetune)",
    image("./img/resnet50_confusion_matrix_normalized.png")
  ),

  figure(
    caption: "Per class metrics of ResNet-50 (full finetune).",
    image("./img/resnet50_per_class_metrics.png")
  ),

  figure(
    caption: "Training history of ResNet-50 (Full finetune)",
    image("./img/resnet50_training_history.png")
  )
)



===== EfficientNetV2-S
EfficientNetV2-S with Gradual Unfreezing generalizes well. Its confusion matrix is cleaner, with fewer off‑diagonal errors than ResNet-50. The normalized matrix shows big gains on tough classes: Koilonychia up to 75.00 percent and Terry’s Nails at 92.86 percent. Per-class precision and recall sit above 80 percent for most classes, consistent and steady. Training history is smooth, validation loss tracks training loss, which supports gradual unfreezing as a good fit here.

#grid(
  columns: (1fr),
  gutter: 2em,

  figure(
    caption: "Confusion matrix of EfficientNetV2-S (gradual unfreeze)",
    image("./img/efficientnet_confusion_matrix.png")
  ),
  figure(
    caption: "Normalized confusion matrix of EfficientNetV2-S (full finetune)",
    image("./img/efficientnet_confusion_matrix_normalized.png")
  ),
  figure(
    caption: "Per class metrics of EfficientNetV2-S (gradual unfreeze).",
    image("./img/efficientnet_per_class_metrics.png")
  ),
  figure(
    caption: "Training history of EfficientNetV2-S (gradual unfreeze)",
    image("./img/efficientnet_training_history.png")
  ),
)

===== SwinV2-T
SwinV2-T with Gradual Unfreezing hits some of the highest per-class scores. The confusion matrix is sparse, and the normalized matrix shows 100.00 percent for Pitting and 93.10 percent for Blue Nail. It also does well on Muehrcke’s Lines at 87.50 percent, beating the CNN baselines. Per-class metrics show high F1 scores across classes, global context seems to help. Training accuracy rises fast and stays stable, no wild swings.

#grid(
  columns: (1fr),
  gutter: 2em,
  figure(
    caption: "Confusion matrix of SwinV2-T (gradual unfreeze)",
    image("./img/swin_confusion_matrix.png")
  ),
  figure(
    caption: "Normalized confusion matrix of SwinV2-T (full finetune)",
    image("./img/swin_confusion_matrix_normalized.png")
  ),
  figure(
    caption: "Per class metrics of SwinV2-T (gradual unfreeze).",
    image("./img/swin_per_class_metrics.png")
  ),
  figure(
    caption: "Training history of SwinV2-T (gradual unfreeze)",
    image("./img/swin_training_history.png")
  ),
)

===== ConvNeXt-Tiny
ConvNeXt-Tiny with Gradual Unfreezing ends up the most balanced overall. The confusion matrix has the fewest total errors across the ten classes. The normalized matrix stays above 80 percent for every class, with 97.22 percent on Melanonychia and 87.50 percent on Muehrcke’s Lines. Per-class metrics are strongest in harmonic mean, so precision and recall line up best here. Training history is stable too, loss drops without bumps, showing the modernized CNN design really works for this nail task.

#grid(
  columns: (1fr),
  gutter: 2em,
  figure(
    caption: "Confusion matrix of ConvNeXt-Tiny (gradual unfreeze)",
    image("./img/convnext_confusion_matrix.png")
  ),

  figure(
    caption: "Normalized confusion matrix of ConvNeXt-Tiny (full finetune)",
    image("./img/convnext_confusion_matrix_normalized.png")
  ),

  figure(
    caption: "Per class metrics of ConvNeXt-Tiny (gradual unfreeze).",
    image("./img/convnext_per_class_metrics.png")
  ),

  figure(
    caption: "Training history of ConvNeXt-Tiny (gradual unfreeze)",
    image("./img/convnext_training_history.png")
  ),
)


==== Model Interpretability
To reduce the black box problem, the researchers Grad-CAM and saliency maps to show where the models look. For CNNs like ResNet-50 and EfficientNetV2-S, heatmaps point to nail‑plate regions, like Melanonychia discoloration or Clubbing structure, that drive the decision. That visual check shows the models focus on the right clinical cues, not background noise. But SwinV2-T still resists easy interpretability, because its attention blocks do not output the same feature maps, so there is a trade-off between accuracy and explainability, a real trade-off.

#figure(
  caption: "Sample saliency maps using different cam tools",
  image("./img/saliency-interpretability.png", width: 58%)
)


=== Research Objective 5
#set image(width: 70%)
To deploy the models in a prototype application that provides interpretable systemic disease predictions from fingernail images, designed for potential use in clinical decision support or health screening applications.

The researchers built a Flask-based prototype that connects the trained PyTorch models to a Bayesian inference engine, forming a complete image-to-disease pipeline. The application has authenticated user accounts, an image upload workflow, and a result viewer that shows the detected nail feature, model confidence, attention maps, performance metrics, and ranked systemic disease probabilities. A model loader pulls in the selected model — EfficientNetV2-S, VGG-16, ResNet-50, ConvNeXt-Tiny, or SwinV2-T — and a classification service runs it in-process. The Bayesian inference service then takes the curated statistical dataset and confusion matrices stored in the project's metrics directory to compute calibrated posterior probabilities of systemic diseases given whatever nail features were detected.

#grid(
  columns: (1fr),
  gutter: 2em,

  figure(
    caption: [Prototype Dashboard & Upload Workflow],
    image("./img/prototype-dashboard.png")
  ),

  figure(
    caption: [Model Selection & Classification Result],
    image("./img/model-selection.png")
  )
)

For clinical transparency, the prototype generates interpretability visualizations — Grad-CAM, Grad-CAM++, and LayerCAM — and saves the overlays to the uploads folder so they can be viewed next to the original image. Each analysis gets persisted as a diagnosis record in the instance database, storing classification results, confidence scores, the model used, disease probabilities, and visualization filenames. Users can revisit previous analyses through a history and dashboard view. There is also a quality-check endpoint that runs real-time image quality assessment before the analysis starts, giving users immediate feedback if the upload is not usable.

#grid(
  columns: (1fr),
  gutter: 2em,

  figure(
    caption: [Interpretability Visualizations],
    image("./img/interpretability-visualization.png")
  ),

)

Reproducibility and transparency are built into the design. Per-class probabilities and full model metrics load from stored files and render in the UI. The Bayesian engine uses those same metrics for calibration. On the result page, users see the model's raw confidence distribution, calibrated disease posterior rankings, literature associations for the detected feature, interpretability visualizations, and clear medical disclaimers with recommendations.

#grid(
  columns: (1fr),
  gutter: 2em,

  figure(
    caption: [Bayesian Inference & Probability Rankings],
    image("./img/inference-rankings.png")
  ),

)

The prototype has known limitations. It runs on CPU by default, depends on locally stored model weights and the curated statistical dataset, and is meant for local or research use — not clinical deployment. It is explicitly not a diagnostic device. Future improvements the researchers identified include Docker containerization, GPU support for faster inference, model ensembling, secure API endpoints for mobile clients, and prospective clinical validation to check real-world utility and safety.

#grid(
  columns: (1fr),
  gutter: 2em,

  figure(
    caption: [History & Persisted Analyses],
    image("./img/history-persisted-analyses.png")
  ),

)



#pagebreak()
#metadata("Chapter 4 end") <ch4-e>

#metadata("Chapter 5 start") <ch5-s>
#chp[Chapter V]
#set image(width: 100%)
#h2(outlined: false, bookmarked: false)[Summary, Conclusions, Recommendations]

This chapter presents the summary, conclusions, and recommendations derived from the development and evaluation of a deep learning-based system for the probabilistic detection of systemic diseases using fingernail biomarkers.

=== Summary
This study set out to build a deep learning system that uses fingernail biomarkers to probabilistically detect systemic diseases. The following are the key findings, organized by research objective.

==== Data Collection and Curation
A labeled image dataset of 7,258 images across 10 nail feature classes — Clubbing, Koilonychia, Terry's Nails, and others — was acquired from Roboflow. A dermatologist verified the dataset for clinical relevance. On the statistical side, the researchers curated a dataset from 33 peer-reviewed clinical and epidemiological studies, mapping 31 associations between nail features and systemic diseases (Clubbing to Lung Cancer, Clubbing to Cardiovascular Disease, and so on). That dataset included conditional probabilities and population prevalence figures, which fed directly into the Bayesian inference engine.

==== Preprocessing and Augmentation
Images were resized to 224×224 pixels and normalized using ImageNet mean and standard deviation values — standard preprocessing to keep things compatible with PyTorch. To make up for the limitations of a fixed dataset and push model robustness further, the researchers applied geometric and photometric augmentations: flipping, rotation, brightness adjustment. Each source image effectively produced multiple training variants, which helped with generalization.

==== Model Development and Training
Five architectures were trained: VGG-16, ResNet-50, EfficientNetV2-S, SwinV2-T, and ConvNeXt-Tiny. The pipeline had two phases. A CNN or ViT model handled the visual classification of the nail feature first. Then a Bayesian inference engine took the classified feature along with user demographics and calculated posterior probabilities for systemic diseases.

==== Performance Evaluation
ConvNeXt-Tiny and SwinV2-T performed best, reaching classification accuracies around 88.93% and 88.27%. The newer architectures — ConvNeXt, Swin, EfficientNet — all did better with Gradual Unfreezing, while VGG-16 and ResNet-50 needed Full Fine-Tuning to get their best results. Saliency Maps and Grad-CAM were applied to the CNN-based models to show which parts of the nail plate the model focused on, things like discoloration or texture changes. That helped address the "black box" problem and made the predictions easier to trust.

==== Deployment
The top-performing models were built into a web-based prototype. Users upload a nail image, enter their age and sex, and the system classifies the nail feature with a confidence score. A calibrated Bayesian inference engine then outputs a ranked list of probable systemic diseases — something like "Psoriasis: 91.24%." The result is an interpretable screening tool, which was the goal.

=== Conclusions
Based on the findings, the following conclusions were drawn:

==== Feasibility of Deep Learning for Nail Biomarkers
Modern architectures like *ConvNeXt-Tiny* and *SwinV2-T* can classify subtle nail deformities and discolorations effectively. Visually similar conditions — the kind that would be easy to confuse — were distinguished with high accuracy, as long as the models were trained with proper augmentation and transfer learning. Deep learning works for this domain.

==== Architecture-Specific Training Strategies
No single training approach works across all architectures. Modern, deeper networks got their best results from *Gradual Unfreezing*, which keeps pretrained features intact while adapting to the nail feature domain. Older, shallower networks like VGG-16 needed *Full Fine-Tuning* instead — their weights required more extensive adjustment to handle the specifics of nail feature extraction. The strategy has to match the architecture.

==== Probabilistic Inference as a Safety Layer
Adding *Bayesian Inference* on top of the deep learning classifier changes the system fundamentally. It stops being just an image classifier and becomes a screening tool with clinical relevance. The mathematical link between nail features and systemic diseases, grounded in prevalence data, means the system produces risk assessments rather than definitive diagnoses. Definitive diagnoses should stay with medical professionals. This approach handles the ethical and practical constraints of using AI in healthcare — the system flags possibilities without overstepping.

==== Necessity of Demographic Context
Visual data on its own is not enough for systemic risk assessment. Adding patient demographics — age and sex — to the inference engine made a real difference in how accurate the probability outputs were. The system can filter out conditions that do not make sense for a given patient, like flagging pediatric diseases in an adult. Without that demographic layer, the results would be logically weaker.

=== Recommendations
In light of the findings and conclusions, the researchers offer the following recommendations:

==== For Future Researchers and Developers
===== Expansion of Datasets
A locally curated dataset of fingernail images from Philippine hospitals would help account for ethnic skin tones and regional disease prevalence. The expert consultation noted that nail features are generally consistent across populations, but having verified local cases in the training data would still make the system more robust. Future studies should prioritize this.

===== Implementation of Object Detection
Poor-quality uploads — background clutter, images that are not even nails — are a real problem for the system right now. Adding an object detection model like YOLO to automatically crop and center the nail plate before classification would handle most of that. Future iterations should build this in.

===== Inclusion of Lifestyle Factors
The Bayesian inference engine should eventually take in "Occupation" and "Hobbies" as inputs. The dermatologist expert pointed out that external trauma from manual labor or chemical exposure can produce nail changes that look like systemic signs. Filtering for those factors would cut down on false positives.

==== For Medical Professionals and Health Institutions
===== Clinical Validation
Medical institutions should work with technical researchers to test the system's probabilistic outputs against confirmed patient diagnoses. A patient flagged for "High Probability of Renal Failure" based on nail features — does blood chemistry actually confirm that? That kind of ground-truth validation is what the system needs next.

===== Screening Tool Utilization
In rural or resource-limited settings, this system could serve as a preliminary triage tool. Providers could use it to flag patients showing high-probability biomarkers for serious systemic conditions and get them referred to specialists sooner.

==== For the General Public
===== Complementary Use
The system's outputs are probabilistic risk assessments. They are not diagnoses. A high-probability result means it is worth seeing a doctor and getting a proper examination — not that something has been confirmed.

#metadata("Chapter 5 end") <ch5-e>
#metadata("postlude start") <post-s>
#pagebreak()


#bibliography("reference.bib", style: "american-psychological-association", title: [Literature Cited])
#pagebreak()



#h1(hidden: true)[Appendices]
#text(size: 56pt)[#align(center + horizon)[*Appendices*]]
#pagebreak()


#show heading: none
#h2(hidden: true, outlined: false)[Appendix A]
#align(center + horizon)[
  #grid(
    align: center + horizon,
    row-gutter: 1.8em,
    columns: 1fr,
    text(size: 56pt)[Appendix A],
    text(size: 28pt)[Technical Background]
  )
]
#pagebreak()

#h3(hidden: true)[Expert Interview Transcription -- 07/03/2025]
#[
  #set par(spacing: 1em, leading: 1em)
  #include "./expert-interview.typ"
]

#pagebreak()

#h3(hidden: true)[RC Defense Transcription -- 07/29/2025]
#[
  #set par(spacing: 1em, leading: 1em)
  #include "./rc-defense-transcription.typ"
]

#pagebreak()
#h3(hidden: true)[Ma'am Villarica Consultation -- 08/19/2025]
#[
  #set par(spacing: 1em, leading: 1em)
  #include "./mam-mia-consultation.typ"
]

#pagebreak()
#h3(hidden: true)[Sir Bernardino Consultation -- 09/05/2025]
#[
  #set par(spacing: 1em, leading: 1em)
  #include "./sir-mark-consultation.typ"
]

#pagebreak()
#h3(hidden: true)[Sir Bernardino Consultation –- 10/07/2025]
#[
#set par(spacing: 1em, leading: 1em)
#include "./sir-mark-consultation2.typ"
]

#pagebreak()
#h3(hidden: true)[Ma’am Villarica Consultation –- 10/08/2025]
#[
  #set par(spacing: 1em, leading: 1em)
  #include "mam-mia-consultation2.typ"
]

#pagebreak()
#h3(hidden: true)[Sir Estalilla Consultation -- 10/13/2025]
#[
  #set par(spacing: 1em, leading: 1em)
  #include "./sir-estalilla-consultation.typ"
]

#pagebreak()
#h3(hidden: true)[Datasets]

#h4(hidden: true)[Beau’s Line]
#image("./img/dataset-beau.png")

#h4(hidden: true)[Blue Finger]
#image("./img/dataset-blue.png")

#h4(hidden: true)[Clubbing]
#image("./img/dataset-clubbgin.png")

#pagebreak()
#h4(hidden: true)[Healthy Nail]
#image("./img/dataset-healthy.png")

#h4(hidden: true)[Koilonychia]
#image("./img/dataset-koily.png")

#h4(hidden: true)[Melanonychia]
#image("./img/dataset-melano.png")

#pagebreak()
#h4(hidden: true)[Muehrcke’s Lines]
#image("./img/dataset-merchue.png")

#h4(hidden: true)[Onychogryphosis]
#image("./img/dataset-onycho.png")

#h4(hidden: true)[Pitting]
#image("./img/dataset-pitting.png")

#pagebreak()
#h4(hidden: true)[Terry’s Nail]
#image("./img/dataset-terry.png")

#h4(hidden: true)[Statistical Dataset]
#image("./img/dataset-stat.png")

#pagebreak()

#h3(hidden:true)[Actual Testing Pictures]
#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 2em,

  image("./img/interview (1).jpg"),
  image("./img/interview (2).jpg"),
  image("./img/interview (3).jpg"),
  image("./img/interview (4).jpg"),
  image("./img/interview (5).jpg"),
  image("./img/interview (6).jpg"),
),

#pagebreak()

#h3(hidden: true)[System Evaluation Questionnaire]
#image("./img/system-evaluation-questionnaire.jpg", width: 100%)
#image("./img/system-evaluation-questionnaire2.jpg", width: 100%)
#image("./img/system-evaluation-questionnaire3.jpg", width: 100%)


#pagebreak()

#h3(hidden: true)[Hardware and Software Resources]
+ *Software Resources*
  + *Development Environments and Languages*
   - Python
   - Visual Studio Code (VS Code)
   - Google Colaboratory (Colab)
  + *Libraries, Frameworks, and Databases*
    - PyTorch
    - Flask
    - Bootstrap
    - Matplotlib
    - SQLite
  + *Platforms and Version Control*
    - Git & GitHub
    - Hugging Face
  + *AI-Assisted Development Tools*
    - GitHub Copilot
    - Conversational AI (ChatGPT, Google Gemini)
  + *Documentation and Communication*
    - Typst
    - Zotero
    - Google Docs
    - Discord
+ *Hardware Resources*
  + *Cloud Computing Resources*
    - Google Colab GPUs/TPUs
  + *Local Computing Resources*
    - Personal Computers/Laptops: Used by the researchers for:
      - Data collection and curation.
      - Coding and development via Visual Studio Code.
      - Running the local "System Backend" and "Local File System" for the prototype application during testing.
      - Accessing cloud resources (Google Colab) via web browsers.


#pagebreak()

#h3(hidden: true)[User's Manual]

#grid(
  columns: (1fr),
  gutter: 2em,

  image("./img/user-manual (1).png"),
  image("./img/user-manual (2).png"),
  image("./img/user-manual (3).png"),
  image("./img/user-manual (4).png"),
  image("./img/user-manual (5).png"),
  image("./img/user-manual (6).png"),
  image("./img/user-manual (7).png"),
  image("./img/user-manual (8).png"),
  image("./img/user-manual (9).png"),
  image("./img/user-manual (10).png"),
  image("./img/user-manual (11).png"),
)

#pagebreak()

#h2(hidden: true, outlined: false)[Appendix B]
#align(center + horizon)[
  #grid(
    align: center + horizon,
    row-gutter: 1.8em,
    columns: 1fr,
    text(size: 56pt)[Appendix B],
    text(size: 28pt)[Communication Letter & Forms]
  )
]
#pagebreak()

#h3(hidden: true)[Communication Letters]

#image("img/communication-letter-01.jpg", width: 100%, height: 96%)
#pagebreak()

#image("img/communication-letter-02.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/communication-letter-03-florentino.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/Request Letter_page-0001.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/Request Letter_page-0002.jpg", width: 100%, height: 100%)
#pagebreak()


#image("img/FOI Request Form_page-0001.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/FOI Request Form_page-0002.jpg", width: 100%, height: 100%)
#pagebreak()

#h3(hidden: true)[Rating Sheets]

#image("img/01_Title_Proposal_Rating_Sheet_page-0001.jpg", width: 100%, height: 96%)
#image("img/01_Title_Proposal_Rating_Sheet_page-0002.jpg", width: 100%, height: 100%)
#image("img/01_Title_Proposal_Rating_Sheet_page-0003.jpg", width: 100%, height: 100%)
#image("img/01_Title_Proposal_Rating_Sheet_page-0004.jpg", width: 100%, height: 100%)
#image("img/01_Title_Proposal_Rating_Sheet_page-0005.jpg", width: 100%, height: 100%)
#image("img/01_Title_Proposal_Rating_Sheet_page-0006.jpg", width: 100%, height: 100%)

#image("./img/rc-rating-sheet (1).jpg")
#image("./img/rc-rating-sheet (2).jpg")
#image("./img/rc-rating-sheet (3).jpg")

#image("./img/fod-rating-sheet (1).jpg")
#image("./img/fod-rating-sheet (2).jpg")
#image("./img/fod-rating-sheet (3).jpg")


#pagebreak()


#h3(hidden: true)[Summary of Recommendations]
#image("img/Summary_of_Recommendations.jpg", width: 100%, height: 96%)
#pagebreak()

#h3(hidden: true)[ISO Forms]
#image(
  "img/011-Thesis-Adviser-Nomination-Form-&-012-Panel-Member-Nomination-Form_page-0001.jpg",
  width: 100%,
  height: 96%,
)
#pagebreak()

#image(
  "img/011-Thesis-Adviser-Nomination-Form-&-012-Panel-Member-Nomination-Form_page-0002.jpg",
  width: 100%,
  height: 100%,
)
#pagebreak()

#image(
  "img/011-Thesis-Adviser-Nomination-Form-&-012-Panel-Member-Nomination-Form_page-0003.jpg",
  width: 100%,
  height: 100%,
)
#pagebreak()

#image(
  "img/011-Thesis-Adviser-Nomination-Form-&-012-Panel-Member-Nomination-Form_page-0004.jpg",
  width: 100%,
  height: 100%,
)
#pagebreak()

#image(
  "img/011-Thesis-Adviser-Nomination-Form-&-012-Panel-Member-Nomination-Form_page-0005.jpg",
  width: 100%,
  height: 100%,
)

#pagebreak()
#h3(hidden: true)[Turnitin Digital Receipts]
#image(
  "./receipt_CS4B-05-PROBABILISTIC DETECTION OF SYSTEMIC DISEASES USING DEEP LEARNING ON FINGERNAIL BIOMARKERS.pdf"
)
#image(
  "./receipt_10-PAGER.pdf"
)


#pagebreak()
#h2(hidden: true, outlined: false)[Appendix C]
#align(center + horizon)[
  #grid(
    align: center + horizon,
    row-gutter: 1.8em,
    columns: 1fr,
    text(size: 56pt)[Appendix C],
    text(size: 28pt)[Curriculum Vitae]
  )
]
#pagebreak()

#h3(hidden: true)[Curriculum Vitae]

#image("./img/javier-resume (1).pdf")
#image("./img/MHAR_ANDREI_MACAPALLG_CV_Latest.pdf")
#image("./img/seanrei-cv.jpg")


#metadata("postlude end") <post-e>
