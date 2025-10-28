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
  *JUNE 2025*
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

  The thesis entitled *"#upper(title)"* prepared and submitted by *GERON SIMON A. JAVIER*, *MHAR ANDREI C. MACAPALLAG*, and *SEANREI ETHAN M. VALDEABELLA* in partial fulfillment of the requirements for the degree of *BACHELOR OF SCIENCE IN COMPUTER SCIENCE*, major in *INTELLIGENT SYSTEM* is hereby recommended for approval and acceptance.
  \
  \
  \
  #grid(
    columns: (2fr, 1fr, 1fr),
    [], [], align(center)[*Mia V. Villarica* \ Thesis Adviser],
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
    [*MARK P. BERNARDINO* \ Member],
    [*VICTOR A. ESTALILLA JR.* \ Member],
    text(size: 11pt)[*MICAH JOY FORMARAN* \ Member],
    text(size: 11pt)[*JHONJHON P. ZOTOMAYOR* \ Member],
    grid.cell(colspan: 2)[*MARIA LAUREEN B. MIRANDA, LPT, MIT* \ Research Implement Unit Head],
  )

  #v(1.5em)#line(length: 100%)#v(0.5em)

  Accepted and approved in partial fulfillment of the requirement for the degree of *BACHELOR OF SCIENCE IN COMPUTER SCIENCE*, Major in *INTELLIGENT SYSTEM*.
  \
  \
  \
  #grid(
    columns: (1fr, 1fr),
    align: center,
    [], [*MIA V. VILLARICA, DIT* \ Dean/Associate Dean],
  )
  #v(1fr)
  #grid(
    columns: (1fr, 1fr),
    align: center,
    [*BENJAMIN O. ARJONA, Ed. D.* \ Chairperson, Research and Development],
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

  To their Technical Editor, *MS. MICAH FORMARAN*, who thoughtfully corrected the manuscript's format and content;
  \
  \

  To their Statistician, *MR. VICTOR A. ESTALILLA JR.*, for his guidance on the structure of the data sample and her help in completing the data sampling for the study;
  \
  \

  To their Language Critic, *MR. JOHNJOHN ZOTOMAYOR*, for being helpful in checking and revising the manuscript's grammar and its structure;
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

  #lorem(300)
  \
  \
  \
  _*Keywords:* Image Processing, Deep Learning, Machine Learning, Fingernail Disease, Systemic Disease, Convolutional Neural Networks_
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
  [Accuracy is a standard evaluation metric used to assess the performance of CNN models, with various models achieving different accuracy rates.],

  [*Artificial Intelligence (AI)*],
  [AI is described as a transformative force in addressing healthcare challenges, particularly through advancements in image processing and probabilistic modeling, with AI-driven diagnostic systems potentially improving the accuracy and speed of disease diagnosis.],

  [*Bayesian Inference*],
  [Bayesian Inference is a probabilistic model used in the study, alongside Naïve Bayes, to infer systemic disease probabilities, and is supported by the knowledge integration module.],

  [*Batch Learning / Mini Batches*],
  [Training was conducted using mini batches of 32 images per iteration to enhance training efficiency while balancing generalization and convergence speed.],

  [*Confidence Intervals*],
  [Confidence Intervals are an evaluation metric for probabilistic models, with the system providing probabilistic risk assessments (e.g., "Diabetes Likelihood: 85%") along with recommendations for medical consultation.],

  [*Convolutional Neural Networks (CNNs)*],
  [CNNs are the primary architecture for analyzing image data in this study, automatically learning spatial hierarchies of features essential for accurate classification of nail abnormalities, and excel at analyzing visual data to identify patterns that may escape human observation.],

  [*Cross Entropy Loss*],
  [Cross Entropy Loss is the loss function employed during model training, specifically used for multiclass classification.],

  [*Deep Learning (DL)*],
  [Deep Learning is a subfield of machine learning that utilizes deep neural networks capable of hierarchical representation learning, enabling end-to-end learning from raw images to disease classification output, which the study aims to develop.],

  [*EfficientNetV2*],
  [EfficientNetV2 (specifically EfficientNetV2 S) is a pre-trained CNN model used in the study that showed strong performance with a relatively lower parameter count and faster training time, making it a competitive choice for lightweight applications and accurate diagnosis.],

  [*F1 Score*],
  [The F1 Score is a standard evaluation metric for CNN models and is also used to evaluate per-class performance and misclassification trends.],

  [*Grad CAM*],
  [Grad CAM is a technique that may be explored for visualization to explain the visual reasoning behind model predictions, enhancing interpretability and transparency.],

  [*Image Augmentation*],
  [Image augmentation involves techniques like horizontal flipping, rotation, and brightness adjustment applied to increase dataset diversity and reduce overfitting, producing multiple versions of each source image.],

  [*Image Classification*],
  [Image classification is the core task of the system, involving classifying images into one of several disease categories, which serves as the basis for subsequent probabilistic inference of systemic conditions.],

  [*Image Preprocessing*],
  [Image preprocessing refers to steps taken before training, such as resizing, format conversion, augmentation, and normalization, to ensure consistency across inputs and compatibility with model architectures.],

  [*Image Processing*],
  [Image processing is a field that has seen advancements, particularly with AI, used to analyze visual data, and is central to the study's focus on probabilistic detection of systemic diseases using deep learning on fingernail biomarkers.],

  [*Machine Learning (ML)*],
  [Machine Learning is a broader field encompassing deep learning, with techniques like Support Vector Machines and CNNs employed in studies to enhance classification accuracy for nails, and is integrated into the study.],

  [*Normalization (Image)*],
  [Input images were normalized using standard ImageNet mean and standard deviation values to ensure compatibility with pre-trained models, enabling more effective transfer learning and stable gradient flow during training.],

  [*Precision*], [Precision is a standard evaluation metric for CNN models.],

  [*Probabilistic Modeling / Probabilistic Inference*],
  [Probabilistic modeling integrates deep learning-based classification with probabilistic inference to estimate the likelihood of systemic diseases, providing actionable insights for users and aiming to offer probabilistic risk assessments.],

  [*Recall*], [Recall is a standard evaluation metric for CNN models.],

  [*RegNetY16GF*],
  [RegNetY16GF is a pre-trained model considered for use in the system that leverages architectural flexibility to achieve higher metrics, albeit at increased parameter complexity, and is integrated into the business logic layer for accurate diagnosis.],

  [*ResNet*],
  [ResNet is a CNN model considered for use in the system that offers a solid baseline due to its residual connections and has been fine-tuned for superior performance in onychomycosis diagnosis compared to dermatologists.],

  [*Sensitivity*], [Sensitivity is an evaluation metric for probabilistic models.],

  [*Specificity*], [Specificity is an evaluation metric for probabilistic models.],

  [*SwinV2-T*],
  [SwinV2-T achieved the highest performance across all evaluated metrics (accuracy, precision, recall, F1 score) among five architectures, despite its computational intensity, and is integrated into the business logic layer for accurate diagnosis.],

  [*Transfer Learning*],
  [Transfer learning involves fine-tuning pre-trained models (e.g., EfficientNetV2 and RegNetY16GF), initially trained on large-scale datasets, using the nail disease dataset to accelerate training and improve performance, with normalization ensuring consistency for effectiveness.],

  [*VGG16*],
  [VGG16 is an older architecture benchmarked in the study that demonstrated the lowest accuracy and F1 score with the highest number of parameters, underscoring its inefficiency for fine-grained classification tasks compared to more modern architectures, although a hybrid VGG16 and Random Forest Model achieved 97.02% accuracy.],

  [*Vision Transformers (ViTs)*],
  [Vision Transformers are explored in the study alongside CNNs for their ability to capture long-range dependencies and attention-based representations, potentially enhancing classification in complex image scenarios, and one model was selected for building.],

  [*Weighted Loss Function*],
  [A weighted loss function is used to address class imbalance within the dataset by assigning class weights inversely proportional to each class's frequency, ensuring underrepresented classes contributed more significantly to the loss during training and mitigating bias toward majority classes.],
)

#heading(level: 3, outlined: false)[Operational Terms]
This section defines any terms or phrases derived from the study operationally, implying the way they were used in the study.

#grid(
  columns: (1fr, 2fr),
  inset: 1em,

  [*Beau's Lines*],
  [Beau's Lines are transverse linear depressions or grooves across the nail plate, resulting from a temporary decrease in nail growth due to severe systemic illness, trauma, drug use, or conditions like Raynaud's disease, diabetes, or zinc deficiency, and have been associated with COVID-19.],

  [*Biomarkers (Fingernail)*],
  [Fingernails are considered a "window to systemic health" and a globally recognized source of biomarkers, revealing early signs of serious conditions through subtle changes in their appearance, which the study focuses on for probabilistic detection of systemic diseases.],

  [*Blue Finger / Cyanosis*],
  [Blue Finger or Cyanosis is a condition characterized by acute bluish discoloration of fingers, potentially with pain, indicating that organs, muscles, and tissues are not receiving enough blood/oxygen, and signifies lower oxygen saturation leading to deoxyhemoglobin accumulation.],

  [*Clubbing (Hippocratic Nails)*],
  [Clubbing, also known as Hippocratic Nails, is a nail abnormality characterized by fingers in the form of "drum sticks" or nails like "watch glasses," where the nail plate curvature is strengthened, and is considered an important early clinical symptom of severe health disorders, mostly related to cardiopulmonary malfunctioning.],

  [*Fingernail Disease / Nail Disorders*],
  [Fingernail diseases are a common problem affecting millions globally, some of which can indicate internal systemic diseases, and the study focuses on their classification and the probabilistic inference of systemic diseases.],

  [*Healthy Nail*], [Healthy nails are smooth, consistent in color, and usually indicate good health.],

  [*Koilonychia*],
  [Koilonychia is a nail abnormality that enhances the accuracy of dermatological examination and alerts clinicians to generalized health issues, though some models may struggle with classifying it.],

  [*Muehrcke's Lines*],
  [Muehrcke's Lines are a nail condition that is the most underrepresented class in the dataset, but some models show strong recall for it, which is critical in a preventive diagnostic context.],

  [*Onychomycosis*],
  [Onychomycosis is a common nail condition for which region-based CNNs and deep learning have demonstrated superior diagnostic performance compared to dermatologists.],

  [*Onychogryphosis*],
  [Onychogryphosis is a nail disease mentioned as an architectural change in nails that constitutes important diagnostic information.],

  [*Pitting*],
  [Pitting refers to small depressions in the nail associated with psoriasis or other systemic diseases, serving as architectural changes that can indicate systemic issues, and some models show improvement in classifying it.],

  [*Preventive Healthcare*],
  [Preventive healthcare is the primary goal of the study, which aims to develop a system empowering individuals globally by providing a non-invasive, accessible tool for early health screening, detection, and actionable recommendations.],

  [*Systemic Diseases*],
  [Systemic diseases are conditions such as diabetes, cardiovascular disorders, and liver conditions that often manifest early through fingernail abnormalities, providing a critical window for intervention, and the study aims for their probabilistic detection using deep learning on fingernail biomarkers.],

  [*Terry's Nails*],
  [Terry's Nails are characterized by white opacification of the nails with effacement of the lunula and distal sparing, most commonly associated with hepatic cirrhosis, and can also be a sequela of other conditions like congestive heart failure, chronic kidney disease, diabetes mellitus, or normal aging.],
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
      [*Table #table-counter.display().* (continued)]
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
Fingernails are often referred to as a “window to systemic health,” #cite(<singal_nail_2015>, form: "normal") as they can reveal early signs of serious conditions such as diabetes, cardiovascular diseases, and liver disorders through subtle changes in their appearance. These abnormalities, such as Beau’s lines (horizontal ridges indicating stress or illness), clubbing (enlarged fingertips linked to heart or lung issues), or pitting (small depressions associated with psoriasis or other systemic diseases), frequently appear before other symptoms become noticeable. Despite their diagnostic potential, these signs are commonly overlooked during routine medical checkups due to their subtle nature and the lack of specialized tools or training for general practitioners to identify them. This oversight delays early intervention, which could significantly improve health outcomes, particularly for individuals in underserved communities with limited access to advanced diagnostics.

The importance of accessible, non-invasive diagnostic methods cannot be overstated, as they empower individuals to monitor their health proactively and seek timely medical advice. However, many people worldwide face barriers to such healthcare services, including geographical isolation, financial constraints, and a lack of awareness about the significance of nail abnormalities. According to #cite(<gaurav_artificial_2025>, form: "prose"), fingernails are a globally recognized source of biomarkers due to their visibility and ease of examination, yet their potential in preventive healthcare remains largely untapped. This gap highlights the urgent need for innovative solutions that can bridge these barriers and democratize early disease detection.

Artificial Intelligence (AI) has emerged as a transformative force in addressing such healthcare challenges, particularly through advancements in image processing and probabilistic modeling. Deep learning techniques, such as Convolutional Neural Networks (CNNs), excel at analyzing visual data, identifying patterns that may escape human observation. For example, a hybrid Capsule CNN achieved a 99.40% training accuracy in classifying nail disorders, showcasing the potential of deep learning in this domain #cite(<shandilya_autonomous_2024>, form: "normal"). Similarly, a region-based CNN demonstrated superior performance to dermatologists in diagnosing onychomycosis, a common nail condition #cite(<han_deep_2018>, form: "normal"). However, these studies often focus solely on classifying nail abnormalities without linking them to underlying systemic diseases, limiting their practical impact on preventive care.

In the Philippines, early efforts like the Bionyx project explored AI-driven fingernail analysis, using Microsoft Azure Custom Vision to identify systemic conditions such as heart, lung, and liver issues through nail images #cite(<chua_student-made_2018>, form: "normal"). While innovative, its reliance on older technology resulted in limited precision compared to modern deep learning models. Internationally, research has emphasized the diagnostic value of nails, with studies employing machine learning techniques like Support Vector Machines and CNNs to enhance classification accuracy #cite(<dhanashree_fingernail_2022>, form: "normal"). Despite these advancements, a critical gap persists: the integration of deep learning-based classification with probabilistic inference to estimate the likelihood of systemic diseases, providing actionable insights for users.

To address the challenges faced in identifying systemic diseases from nail biomarkers, the study aims to develop a deep learning-based system that combines CNN models, specifically, EfficientNetV2-S, VGG-16, ResNet-50 and RegNetY-16GF. The study also utilized a newer vision transformer model, SwinV2-T for nail disorder classification with probabilistic models /*(e.g., Naïve Bayes, Bayesian Inference)*/ to infer systemic disease probabilities. By using publicly available datasets from Roboflow, the system is designed to be a globally accessible, non-invasive tool for early health screening. The proposed system will empower individuals, regardless of their location or socioeconomic status, to monitor their health proactively, offering a user-friendly platform that delivers probabilistic risk assessments and actionable recommendations for medical consultation.

#pagebreak()
=== Research Problem

Systemic diseases such as diabetes, cardiovascular disorders, and liver conditions often manifest early through fingernail abnormalities, providing a critical window for intervention before more severe symptoms arise. These changes, such as discoloration, texture alterations, or structural deformities, are often subtle and require specialized knowledge to interpret, making them easy to overlook during standard medical evaluations. This delay in detection can lead to worsening health outcomes, particularly in areas with limited access to advanced diagnostics, where early intervention could be life-saving.

The advent of AI-driven technologies has shown promise in addressing this challenge by enabling accurate classification of fingernail disorders. For instance, a 2016 study achieved 65% accuracy in detecting diseases based on nail color analysis, but its scope was limited by ignoring texture and shape features #cite(<indi_early_2016>, form: "normal"). More recent studies, such as those employing advanced CNN models, have achieved higher accuracy in nail disorder classification, up to 99.40% in some cases, but they often stop at identifying nail conditions without linking them to systemic diseases #cite(<shandilya_autonomous_2024>, form: "normal"). This gap reduces the clinical utility of these systems, as they fail to provide comprehensive insights that could guide users toward appropriate medical action.

The potential of AI extends beyond healthcare into various sectors, demonstrating its versatility in addressing complex problems. In education, AI tools facilitate personalized learning experiences; in social services, they provide accessible resources to underserved populations; and in healthcare, they can enhance diagnostic accuracy, as seen in studies where CNNs outperformed dermatologists in diagnosing nail conditions #cite(<han_deep_2018>, form: "normal"). A system that integrates deep learning with probabilistic inference could similarly revolutionize preventive healthcare by offering non-invasive screening to individuals worldwide, particularly those who lack access to specialized medical services. However, existing approaches often lack the ability to handle diagnostic uncertainty or provide interpretable results, limiting their effectiveness in real-world applications.

Moreover, the field of medical diagnostics has long sought non-invasive methods to improve early detection, with fingernails emerging as a promising biomarker due to their accessibility. #cite(<pinoliad_onyxray_2020>, form: "prose") demonstrated the feasibility of using machine learning for nail-based disease detection in the Philippines, but their system did not incorporate probabilistic inference for systemic diseases. This highlights the need for a more integrated approach that not only classifies nail disorders but also estimates the likelihood of underlying conditions, empowering users with actionable health insights.

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

+ How can a diverse dataset of at least 3,000 fingernail images across multiple classes be gathered, prepared, preprocessed, and curated to ensure compatibility with deep learning frameworks while addressing issues like class imbalance and data quality?
+ How can researchers systematically collect and curate statistical data on systemic diseases associated with nail features into a usable dataset, and how can this dataset be applied using Bayesian inference for systemic disease inference?
+ How can the reliability and accuracy of the deep learning model be ensured through rigorous training and evaluation and comparison against benchmarks from existing studies?
+ How can explainability methods, such as Grad-CAM or attention-based visualizations, be implemented in deep learning models for fingernail analysis to provide interpretable and explainable results?
+ Which deep learning model demonstrates superior performance for nail disease classification, and how do standard evaluation metrics (e.g., accuracy, precision, recall, F1-score for CNNs; confidence intervals, sensitivity, specificity for probabilistic models) inform the selection of the optimal model?
+ How can the best-performing model be deployed in a prototype application to provide interpretable systemic disease inference from fingernail images, and what are the key challenges in ensuring its suitability for clinical decision support or health screening?


=== Research Objectives
The main objective of the study is to design, develop  and evaluate a deep learning-based system for the classification of nail features that achieves at least 80% accuracy by December, and integrating Bayesian inference for the detection of the probabilities of systemic diseases, providing a non-invasive, accessible, and cost-effective tool to enhance preventive healthcare for individuals globally.

Specifically, this study seeks to achieve the following objectives:
+ To obtain a publicly available fingernail image dataset from Roboflow, consisting of at least 3,000 labeled images across a minimum of 5 distinct nail feature classes, with each image meeting a minimum resolution of 224×224 pixels, and the dataset will be verified by a dermatologist. In parallel, to curate a statistical dataset to be used for inference using Bayesian inference, containing percentage-based associations between these nail feature classes and systemic diseases derived from published clinical, epidemiological studies, and literature.
+ To apply standardized preprocessing steps including resizing and normalization to ensure consistency and suitability for deep learning, and to augment the image dataset by at least 30% using systematic geometric and photometric transformations to enhance model generalization and robustness for systemic disease classification.
+ To experiment, develop and train multiple deep learning models (EfficientNetV2S, VGG16, ResNet50, RegNetY-16GF, and SwinV2-T) on the dataset to accurately classify nail features and to make systemic diseases inferences using Bayesian inference from the statistical dataset of systemic diseases.
+ To evaluate and compare the performance of the trained models using standard metrics, including accuracy, precision, recall, and F1-score for convolutional neural networks (CNNs) and apply explainability and interpretability methods for the algorithms.
+ To deploy the models in a prototype application that provides interpretable systemic disease predictions from fingernail images, designed for potential use in clinical decision support or health screening applications.

=== Research Framework
This section outlines the theoretical and conceptual frameworks that underpin the study, providing a structured approach to developing the proposed system.

==== Theoretical Framework
A theoretical framework serves as a foundational structure of concepts, definitions, and propositions that guide research by explaining or predicting phenomena and the relationships between them. #cite(<vinz_what_2022>) states that a theoretical framework serves as a foundational review of existing theories that functions as a guiding structure for developing arguments within a researcher's own work. It explains the established theories that underpin a research study, thereby demonstrating the relevance of the paper and its grounding in existing ideas. Essentially, it justifies and contextualizes the research, representing a crucial initial step for a research paper.  The diagram below integrates deep learning and probabilistic modeling to create a comprehensive system for fingernail-based systemic disease detection, drawing inspiration from AI-driven diagnostic methodologies.

#figure(
  image("./img/ANN-architecture.png"),
  caption: flex-caption(
    [
      Artificial neural network architectures with feed-forward and backpropagation algorithm #cite(<jentzen_mathematical_2025>, form: "normal")],
    [Artificial neural network architectures with feed-forward and backpropagation algorithm],
  ),
) <ann-architecture>

@ann-architecture shows the architecture of an artificial neural network (ANN) from the book of #cite(<jentzen_mathematical_2025>) titled "Mathematical Introduction to Deep Learning: Methods, Implementations, and Theory." According to #cite(<jentzen_mathematical_2025>), the structure of an ANN involves several layers. The input layer is the first layer where the initial data is fed into the network. Hidden layers are intermediate layers located between the input and output layers. The output layer is the final layer that produces the network's result.

Within these layers, operations involve affine functions, which use linear transformation matrices (weight matrices) and translation vectors (bias vectors) as their trainable parameters. These are followed by nonlinear activation functions, which introduce complexity, enabling the network to learn intricate patterns. Examples of such activation functions include the Rectified Linear Unit (ReLU), Gaussian Error Linear Unit (GELU), standard logistic (sigmoid), hyperbolic tangent (tanh), softplus, swish, clipping, softsign, leaky ReLU, exponential linear unit (ELU), rectified power unit (RePU), sine, and Heaviside.

In the study, the researchers chose ANN as the main method because of their ability to learn patterns from data. A specific type of ANN called a Convolutional Neural Network (CNN) is used to analyze fingernail images and detect visual features known as fingernail biomarkers, such as color, shape, and texture. These features may reveal signs of systemic diseases. Once the CNN identifies these biomarkers, Bayesian inference is applied to estimate the likelihood of a person having a certain disease. This allows the system to give predictions like "there is an 85% chance of anemia," making the approach useful for early detection and preventive healthcare.

#figure(
  image("./img/cnn-architecture.png"),
  caption: flex-caption(
    [Visual representation of a Convolutional Neural Network (CNN) architecture #cite(<zhou_classification_2017>, form: "normal").],
    [Visual representation of a Convolutional Neural Network (CNN) architecture.],
  ),
) <cnn-architecture>

@cnn-architecture shows the architecture of CNN from the study of #cite(<zhou_classification_2017>). According to #cite(<zhou_classification_2017>), a Deep Convolutional Neural Network (CNN) is a specific type of Deep Neural Network (DNN) designed to leverage the local connectivity of images as prior knowledge, which is particularly beneficial for large image processing tasks. While a conventional DNN connects all nodes in a previous layer to all nodes in the next, leading to a very large number of parameters, a CNN significantly reduces the model size by having each node connected only to its neighborhood nodes in the previous layer. In a convolutional layer, each node connects to a local region in the input, known as a receptive field. Although these nodes form an output layer, they utilize different kernels but share the same weights when computing the activation function. An example of a CNN structure like LeNet-5 illustrates this, featuring convolutional layers and pooling layers as its core convolutional components, followed by flatten and fully connected layers inherited from conventional DNNs.

In the study, the researchers used Convolutional Neural Networks (CNNs) because they are well-known for their strong performance in image processing tasks. According to #cite(<zhou_classification_2017>), CNNs are a type of Deep Neural Network (DNN) designed to take advantage of the way images work by focusing on small local areas rather than connecting every node to each other like in regular DNNs. This makes CNNs more efficient and better at recognizing important features, especially in large images. In this research, CNNs were used to detect nail biomarkers from fingernail images by learning patterns such as shapes, textures, and color differences. Their ability to capture local visual details through convolutional and pooling layers made them a reliable choice for comparing different models in nail image analysis.

#figure(image("./img/transformer-architecture.png"), caption: flex-caption(
  [
    Vision Transformer (ViT) Architecture for Image Classification #cite(<dosovitskiy_image_2020>, form: "normal").],
  [Vision Transformer (ViT) Architecture for Image Classification.],
)) <transformer-architecture>


@transformer-architecture shows the architecture of ViT from the study of #cite(<dosovitskiy_image_2020>). In their study, they state that the Vision Transformer (ViT) architecture adapts a standard Transformer, commonly used in Natural Language Processing, for image recognition tasks by treating images as sequences of image patches. To achieve this, an input image is first split into a sequence of fixed-size, non-overlapping 2D patches, which are then flattened. These flattened patches are subsequently mapped to a constant latent dimension through a trainable linear projection, resulting in "patch embeddings". To preserve positional information, learnable 1D position embeddings are added to these patch embeddings. Similar to BERT's `[class]` token, an extra learnable "classification token" is prepended to this sequence of embedded patches, and its state at the output of the Transformer encoder serves as the image representation for classification. This entire sequence of vectors is then fed into a standard Transformer encoder, which consists of alternating layers of multi-headed self-attention (MSA) and MLP blocks, with Layer Normalization applied before each block and residual connections after. Finally, a classification head, implemented as a Multi-Layer Perceptron (MLP) at pre-training and a single linear layer at fine-tuning, is attached to the output of the classification token to perform the classification task. This design incorporates very few image-specific inductive biases, unlike Convolutional Neural Networks (CNNs).

In the study, the researchers used a Vision Transformer (ViT) model because it offers a new way to analyze images by treating them as sequences of patches, similar to how text is processed in Natural Language Processing. Based on #cite(<dosovitskiy_image_2020>), this design allows the model to focus on different parts of the image and capture important visual patterns without relying on built-in image rules like in CNNs. This makes ViT especially useful for detecting fine details in fingernail images, such as color or texture changes, which are important for identifying nail biomarkers. By using ViT, the researchers aimed to explore whether this newer method could better detect subtle features in the nails that may not be as easily captured by traditional CNNs.

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

The study relies on the use Bayes’ theorem for the inference, as shown in @bayes-formula. According to @hayes_bayes_2025, Bayes' Theorem is a mathematical formula for determining conditional probability. Conditional probability is the likelihood of an outcome occurring based on a previous outcome in similar circumstances. Thus, Bayes' Theorem provides a way to revise or update an existing prediction or theory given new evidence.

@rao_medical_2023 points out that every decision in clinical practice naturally follows Bayesian thinking. This shows that the theorem is useful for diseases that affect multiple parts of the body. The main advantage of Bayes’ theorem is that it allows a doctor to update their initial guess, or prior probability, as more evidence comes in. In medicine, diagnosis usually starts with a list of possible conditions, which gets narrower as doctors gather test results, observations, and data about how common the diseases are. This step-by-step updating process is exactly how Bayesian inference works.

The value of using probabilities in clinical predictions is very important. A single, fixed prediction can give a false sense of certainty and does not help with unclear or borderline cases. In comparison, a full probability distribution over possible diseases gives much more useful information #cite(<chen_probabilistic_2021>, form: "normal"). This allows a doctor to see not only the most likely diagnosis but also how likely other possible conditions are. This directly supports making a differential diagnosis, where multiple conditions are considered #cite(<semigran_comparison_2016>, form: "normal"). Probabilities also allow doctors to set decision thresholds. For example, if a disease is very aggressive, a doctor may act even if the probability is low to avoid missing it. For less serious conditions, a higher probability may be required before taking action, to limit extra tests and reduce patient anxiety. This trade-off is explained in decision curve analysis, which measures the overall benefit of using different probability thresholds #cite(<vickers_decision_2006>, form: "normal").

The Bayesian framework also gives a clear way to provide personalized risk assessment, which is an important part of modern precision medicine. The prior probability, $P(A)$, does not have to stay the same for everyone. It can be updated using patient-specific details like age, sex, genetics, or other health conditions. By adding this information, the model produces a personalized probability that shows the risk for that individual. This shifts the model from being a general classifier into a tool that can bring together different types of patient data in a principled, probabilistic way. The result is a more complete and clinically useful assessment #cite(<chatzimichail_software_2024>, form: "normal").


#figure(
  kind: "equation",
  [
    $P("Disease"|"Feature")=(P("Disease") dot P("Feature"|"Disease"))/P("Feature")$
  ],
  caption: [Representation of Bayes’ Theorem for calculating the conditional probability of disease occurrence based on observed features],
)<bayes-application>

@bayes-application explains how the probability of having a systemic disease can be updated after noticing a certain nail feature. In this study, the researchers use Bayes Theorem to connect nail features with disease probabilities. On the left side, $P("Disease"|"Feature")$ is the probability that a person has the disease when the feature is present. This is the main value the researchers want to find. The numerator has two parts. The first, $P("Feature"|"Disease")$, shows how likely the feature is to appear if the disease exists. The second, $P("Disease")$, shows the prior probability, or how common the disease is in the population. When multiplied, these two give the joint probability of both the disease and the feature happening together. The denominator, $P("Feature")$, is the overall chance of the feature showing up in the population, whether or not the disease is present. This works as a normalizing factor so the result stays a proper probability. Using this approach, the researchers highlight that Bayes’ Theorem creates a more accurate probability by combining how strongly a feature relates to a disease with how often both occur in the population. This updated value helps show if a feature is a dependable sign of a disease.

#figure(
  image("./img/shandilya-theoretical.jpg", width: 75%),
  caption: flex-caption(
    [End-to-end framework for nail image classification using deep learning models. #cite(<shandilya_autonomous_2024>, form: "normal")],
    [End-to-end framework for nail image classification using deep learning models.],
  ),
) <theo-shandilya>

@theo-shandilya is a descriptive figure of the framework used to achieve the process of nail disease classification. From the figure, it can be noticed that data gathering is the very first step in the proposed process, which means a collection of images of nails with different conditions to prepare a dataset for testing and training purposes. For this study, the Nail Disease Detection dataset has been used to gather different nail disease images. These preprocessed images are resized to a resolution and, subsequently, undergo several data augmentation techniques like shearing, rotation by 20 degrees, shifting based on width and height, zooming, and horizontal flipping to diversify the dataset. The images are standardized so that they become suitably fit for the model and are then divided into three subsets: training, validation, and testing sets.

In the study, the researchers based their work on a framework by #cite(<shandilya_autonomous_2024>), where a deep learning system using CNN and CapsNet was used to detect nail diseases from images. Their model first learned important patterns using a Convolutional Neural Network (CNN), and then used Capsule Networks (CapsNet) to better understand shapes and features in the images.

The researchers improved this framework by replacing the CNN-CapsNet model with a Vision Transformer (ViT). Vision Transformers divide images into smaller patches and learn how these patches are related. This helps the model understand both the small details and the overall structure of the image. Unlike CNNs, which focus on nearby pixels, Vision Transformers can look across the whole image at once.

The study also expanded the types of nail conditions that the model can detect. Instead of just a 6 nail classifications, the researchers included 10 different nail classifications, specifically beau’s line, blue finger, clubbing, healthy nail, koilonychia, melanonychia, muehrcke’s lines, onychogryphosis, pitting, and terry’s nail.

The study also went a step further by connecting each nail condition to possible systemic diseases. For example, some nail problems might be linked to heart disease, anemia, or cancer. This connection helps the model not just recognize the nail condition, but also suggest what health issues might be related.

#figure(image("/img/agile.png"), caption: flex-caption(
  [AGILE Development Cycle #cite(<okeke_agile_2021>, form: "normal")],
  [AGILE Development Cycle],
)) <agile>

@agile shows the AGILE development cycle, consisting of six phases: Requirements, Design, Development, Testing, Deployment, and Review. In the study, the researchers used the Agile development cycle to manage the project efficiently and adapt to changes throughout the research process. This approach was chosen because it supports step-by-step progress and allows the researchers to make improvements based on testing and feedback. During the Development phase, the models for detecting nail biomarkers (ViT and CNNs) and predicting disease risk (Bayesian inference) were built. In the Testing phase, model accuracy and performance were evaluated. For Deployment, the researchers used Flask, a lightweight web framework, to create a simple and accessible interface where users can upload fingernail images and get predictions. The Review phase helped the researchers assess results and plan refinements. Using Agile helped ensure that each part of the system was built, tested, and improved in cycles, leading to a more reliable and responsive final product.


==== Conceptual Framework
The conceptual framework provides a practical workflow for implementing the theoretical foundation, detailing the process from data collection to system deployment. It is divided into three phases: input, process, and output.


#context {
  [#figure(
    image("img/ConceptualFramework.png"),
    caption: [Conceptual Framework of the Study],
    placement: bottom,
  ) <conceptual-framework>]
}

As illustrated in @conceptual-framework, the input phase involves collecting a dataset of at least 3,000 labeled fingernail images with a minimum resolution of 224x224 from Roboflow. The processing phase includes data cleaning (resizing and normalization) and augmentation (flipping, scaling, and brightness adjustment) to enhance dataset diversity. Feature extraction using CNNs, such as ResNet-50, VGG-16, RegNetY-16GF, and EfficientNetV2, precedes model training with a split dataset (80% training, 20% testing), employing CNNs for classification and literature-based inference. Evaluation metrics (sensitivity, recall, and confidence intervals) guide hyperparameter tuning, leading to the selection of the best-performing model. The output phase delivers probabilistic classifications of nail disorders, systemic disease likelihoods (e.g., diabetes: 85%), and recommendations for medical consultation, with deployment in a web application for global accessibility.
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
- The study will cover classifying nail features ranging 10 classes: Beau's Lines, Blue Nails, Clubbing, Healthy Nail, Koilonychia, Melanonychia, Muehrcke's Lines, Onychogryphosis, Pitting, and Terry's Nails.
- The image dataset will be trained on five models: Resnet-50, VGG-16, RegNetY-16GF, EfficientNetV2-S, and SwinV2-T. The researchers will improve the model through iterative experimentations.
// To be updated to be more specific
- The researchers will implement explainability techniques such as Grad-CAM to understand how the model came up with the classified nail.
- The study makes inferences using Bayesian inference with probabilities derived from the curated statistical dataset.
- The study will be developed on the web using frameworks like Flask.

==== Delimitations
The following delimitations are set by the researchers:
// Include ba natin nail segmentation?
- The developed model does not explicitly identify specific anatomical features of the nail, such as the lunula, nail bed, or nail color. Instead, it leverages the CNN and ViT architectures to automatically learn and detect relevant patterns and features from the labeled dataset, ranging from subtle changes like Muehrcke’s lines to distinct characteristics like onychogryphosis.
- The developed system is not intended to function as a diagnostic tool. Unlike dermatologists or internal medicine physicians who incorporate a patient’s full medical history, laboratory results, and clinical examinations into their assessment, this system relies exclusively on statistical associations between nail features and systemic diseases. Consequently, its inferences are based on general probabilities rather than individualized medical data, which may oversimplify the complexity and multifactorial nature of systemic diseases.
- The model will not analyze how severe a nail feature has become. It will only classify which nail feature it is.


==== Limitations
This study is limited to the following:
- The reliability of nails as a systemic disease detector is tricky and requires more information such as the user's history, work, and pathology.
- The dataset quality and balance can impact the model's ability to make predictions.
- Publicly sourced datasets may lack formal verification from licensed medical professionals, introducing risks of inaccurate labels that could impact classification and inference reliability.
- Local data about prevalence of nail features and nail feature given diseases can be limited.
- Due to the blackbox nature of deep learning models, the models employed have limited interpretability and explainability, which may affect clinical trust and adoption despite strong predictive performance #cite(<doshi_2017_towards>, form: "normal").
- Training complex models require substantial computational resources which may limit the ability to perform extensive hyperparameter tuning.


=== Significance of the Research
The findings of this study are beneficial to individuals and organizations worldwide, offering a non-invasive, accessible tool for early detection of systemic diseases through fingernail biomarkers. By addressing critical gaps in preventive healthcare, the system empowers users to take proactive steps toward better health outcomes. Specifically, the results of this study provide advantages to the following:

*Global Community:* Individuals worldwide, especially those in remote or resource-limited areas, can access early health risk assessments, bridging gaps in healthcare access and empowering them to seek timely medical consultation.

*Healthcare Providers:* Medical professionals can utilize the system as a preliminary screening tool to prioritize patients for further evaluation, improving efficiency in resource-constrained settings and enhancing patient care.

*Public Health Organizations:* The system supports population-level health monitoring by identifying disease prevalence patterns, aiding in the development of targeted health interventions and policies.

*Researchers:* The study serves as a foundation for future research in AI-driven diagnostics, offering insights into integrating deep learning and probabilistic modeling for medical applications.

*Underserved Populations:* Communities in remote or economically disadvantaged regions benefit from a tool that requires no specialized equipment, promoting health equity and reducing disparities in healthcare access.

*Health Tech Developers:* The project provides a blueprint for developing scalable, AI-driven health solutions, encouraging innovation in preventive healthcare technologies.

*Policy Makers:* The results can inform public health policies on integrating AI tools into healthcare systems, improving access to early detection and preventive care on a global scale.

*Educational Institutions:* Medical and technology students can use the system as a learning tool to explore the intersection of AI and healthcare, fostering interdisciplinary education.

#metadata("Chapter 1 end") <ch1-e>
#pagebreak()

#metadata("Chapter 2 start") <ch2-s>
#chp[Chapter II]
#h2(outlined: false, bookmarked: false)[Review of Related Literatures]

This chapter provides a review of relevant research and literature from the various books, websites, magazines, and expertly developed principles to have improved comprehension of the research. The literature is discussed in this chapter, and research projects undertaken by various scholars that have a substantial relationship to the way the study was conducted.  Those who were also a part of this chapter aids in familiarizing oneself with pertinent and comparable material to the current research.

=== Early Non-Invasive Diagnosis in Rural Settings
In a study conducted by #cite(<prajeeth_smart_2023>), he stated that nail disease is a common problem affecting millions of people worldwide, and some nail diseases can be a sign of internal systemic diseases. Diagnosis of nail diseases and internal systemic diseases at an earlier stage could potentially result in improved chances of recovery and extended lifespan.

Timely diagnosis is an important aspect in cutting down on death and enhancing treatment plans, especially with diseases like melanoma, which has very low survival rates if diagnosed late. However, referrals to dermatological specialists and dermatological technologies are frequently unavailable for patients living in rural or underdeveloped regions, and this is why effective automated diagnosis systems are called for #cite(<alruwaili_integrated_2025>, form: "normal").

The study of #cite(<yang_multimodal_2024>) supports this by stating that many diseases are left undiagnosed and untreated, even if the disease shows many physical symptoms. With the rise of Artificial intelligence (AI), self-diagnosis and improved disease recognition have become more promising than ever. AI-driven diagnostic systems can potentially improve the accuracy and speed of disease diagnosis, especially for skin diseases. These tools have shown promising results in the diagnosis of skin diseases, with some studies demonstrating superior performance compared to human dermatologists.

The urgency of research in personal hygiene and nail diseases is exceptionally high due to the significant health implications of untreated nail infections, which can range from minor discomfort to severe systemic health issues. Conducting in-depth research not only aids in identifying risk factors, transmission patterns, and effective prevention strategies but also supports the development of evidence-based interventions. These interventions are crucial for designing educational programs and health campaigns aimed at raising public awareness of the importance of proper nail care. #cite(<ardianto_bioinformatics-driven_2025>, form: "normal")

=== Nail Abnormalities as Systemic Disease Indicators
According to #cite(<shandilya_autonomous_2024>, form: "prose"), the architectural complexity of the nail unit proves to be an important marker for the general health condition and very often represents alterations coinciding with most diseases. Architectural changes in the nails constitute important diagnostic information within a broad spectrum of diseases---from cancer and dermatological diseases to respiratory and cardiovascular diseases. Their study develops an intricate classification system for nail diseases based on the anatomical characteristics of the nail unit for the enhancement of accuracy in dermatological diagnosis. Detailed diagnosis of nail diseases such as onychogryphosis, cyanosis, clubbing, and koilonychia enhances the accuracy of dermatological examination and alerts the clinician to more generalized health issues including hypoxia or anemia due to an iron deficiency. Besides, changes in nails may include manifestations like pitting in psoriasis or onycholysis in eczema: two diseases with a long duration.

Another study conducted by #cite(<abdulhadi_human_2021>) further strengthens the idea that nail abnormalities are important markers for the general health condition. In their study, they stated that many diseases can be predicted by observing the color and shape of human nails in the healthcare domain. They stated that a white spot here, a rosy stain there, or some wrinkle or projection may be an indication of disease in the body. Problems in the liver, lungs, and heart can show up in nails. Doctors observe the nails of patients to get assistance in disease identification. Usually, pink nails indicate a healthy human. Healthy nails are smooth and consistent in color. Anything else affecting the growth and appearance of the fingernails or toenails may indicate an abnormality. A person’s nails can say a lot about their health condition. The need of such systems to analyze nails for disease prediction is because the human eye is having subjectivity about colors, having limitation of resolution and small amount of color change in a few pixels on the nail not being highlighted to human eyes which may lead to wrong result, whereas computers recognize small color changes on nail.

One example of nail abnormalities is described as Beau's Lines. In the paper called "Classification of melanonychia, Beau’s lines, and nail clubbing based on nail images and transfer learning techniques" by #cite(<cosar_sogukkuyu_classification_2023>), they described Beau's lines as horizontal depressions that rise from the nail’s base and spread outward from the white, moon-shaped section of the nail bed. The width of the lines can be used to determine how long the disease has been present.

#cite(<lee_optimal_2022>) stated that Beau's Lines diagnosis is clinical, by inspecting the nail plate for transverse depressions. Ultrasound imaging can help visualize the defect and estimate the timeframe of the insult. AI models like AlexNet with Attention (AWA) have also been applied to classify Beau's lines, achieving an 86.67% testing accuracy in the study conducted by #cite(<shih_classification_2022>).

Further down the list of nail abnormalities is called blue finger or cyanosis. #cite(<mahajan_artificial_2024>) described cyanosis as a benign and rare condition with an idiopathic etiology. It is characterized by an acute bluish discoloration of fingers, which may be accompanied by pain. Blue fingers can mean your organs, muscles, and tissues aren’t getting the amount of blood they need to function properly. Many different conditions can cause cyanosis. Cyanosis is primarily caused by lower oxygen saturation, leading to an accumulation of deoxyhemoglobin in the small blood vessels of the extremities. It indicates a lack of oxygen. Central cyanosis may manifest on mucosa and extremities due to congenital heart diseases.  Peripheral cyanosis is typically diagnosed by examining the nails and digits, caused by vasoconstriction and diminished peripheral blood flow, as seen in cold exposure, shock, congestive cardiac failure, and peripheral vascular disease.

In the study conducted by #cite(<pankratov_nail_2024>), he stated that the color change can also be associated with conditions like liver cirrhosis or certain poisonings, such as cyanide or copper salts. He also stated that cyanosis of the nail bed can be caused by spastic states and decompensated mitral valve defects.

Another example of nail abnormalities is clubbing. #cite(<pankratov_nail_2024>) describes clubbing, also known as hippocratic nails, as fingers in the form of "drum sticks", a change in nails like "watch glasses". For the first time this type of onychodystrophy was described in the I century BC by Hippocrates in patients with pleural empyema. The curvature of the nail plate is strengthened in the transverse and anteroposterior directions, the free edge of the nail is often bent downwards.

#cite(<desir_nail_2024>) define clubbing as distal phalanx thickening resulting in a bulbous appearance of the digit. It is characterized by increased nail bed soft tissue volume, leading to the obliteration of the angle between the proximal nail fold and the nail bed. Initially, it presents with periungual erythema and nail bed softening with a spongy feel. In advanced stages, there is distal phalanx thickening, a bulbous appearance of the digit, a shiny appearance of the nail and periungual skin, nail fold erythema, longitudinal nail plate ridging, and increased vascularity, leading to a lilac hue of the nail bed.

In a study by #cite(<john_digital_2023>), they stated that clubbing can be a clinical manifestation in conditions like Complex Regional Pain Syndrome (CRPS), where the affected limb may also show signs of sympathetic nervous system hyperactivity, cold and cyanotic skin, muscle wasting, tremor, and brittle nails.

Several studies have identified common causes of clubbing. In a study conducted by #cite(<gollins_nails_2021>), they stated that simple clubbing of nails is most commonly caused by an acquired thoracic disease. #cite(<hsu_automated_2024>) identified many causes of clubbing such as lung cancer, chronic obstructive pulmonary disease (COPD), cyanotic congenital heart disease, and idiopathic pulmonary fibrosis. All of which are cardiopulmonary diseases. #cite(<desir_nail_2024>) supported #cite(<hsu_automated_2024>) by stating that respiratory disease is frequently implicated, with 30% of patients having pulmonary disease, cardiovascular diseases, including congenital cyanotic heart disease; gas-trointestinal diseases, including inflammatory bowel disease; endocrine disorders, including Graves’ disease; and rarely hereditary clubbing have also been associated with digital clubbing.

To further go in detail about the causes of nail clubbing, #cite(<desir_nail_2024>) analyzed 407,333 adults in the AoU Registered Tier Dataset v7. In total, 85 participants had a diagnosis of nail clubbing (overall prevalence 0.03%), of which 63.53% had a pulmonary disease versus 36.47% of controls without documented pulmonary pathology. Overall, across both cases and controls, approximately 22% of patients had chronic liver disease, 17% had hypothyroidism, 8% had HIV infection, 5% had congenital heart disease, and 5% had Graves’ disease or hyperthyroidism. Male versus female patients with nail clubbing had decreased odds of having concurrent respiratory disease diagnosis (odds ratio, $0.37$; 95% confidence interval, $0.14–0.92$, $p=0.03$)

Although not a nail abnormality, the researchers also added healthy nails as a baseline class in the nail classification dataset to enhance AI model training.  Healthy nails are pink, smooth, and consistent in color. They are also translucent, hard, and colorless, with their apparent pink color deriving from the underlying highly vascularized nail bed. The white semicircular lunula represents the distal portion of the nail matrix #cite(<abdulhadi_human_2021>, form: "normal").

The dataset used to train the researcher's models also includes Koilonychia, commonly referred to as 'spoon-shaped' nails. It is characterized by brittle, thin, concave nail dystrophy. It can be found in any age group, and it is often associated with severe, chronic iron deficiency that can be attributed to a myriad of causes, such as malnutrition, parasitic infections, malignancies, and more. Treatment depends on the underlying source of the iron deficiency anemia and should resolve once the causative pathology is adequately addressed. With the relative rarity of koilonychia in developed nations, a thorough physical examination and clinical workup of patients is advised, as its presence may be an indication of a significant underlying pathology #cite(<almaguer_koilonychia_2023>, form: "normal").

The researchers also include melanonychia in nail classifications that the model will identify. A brown or black stain on your fingernail or toenail is called melanonychia according to @racelis_what_2025. On one, several, or all of your nails, this discoloration manifests as a dark line.  Since the word "melanonychia" literally translates to "black nail," it reflects the variety of possible hues, which can include solid, shadow-like brown, and black tones. Melanin, the natural pigment in your body that gives your skin and hair their color, is the cause of the dark line. Because your nails are typically clear, the cells in your nail bed, which are composed of the protein clear keratin, typically do not produce much melanin.  But under some circumstances, these melanin cells (melanocytes) may become active or proliferate, resulting in the development of a light to dark nail stain.

As explained by @aseri_basic_2022, longitudinal melanonychia (LM) is the most frequent variant. LM is a linear band from the proximal nail fold (matrix) to the free nail margin. It is a result of an accumulation of excess melanin within the nail plate as a function of either melanocytic hyperplasia or melanocytic activation. An augmentation in melanin production by a normal number of melanocytes is termed melanocytic activation. But melanocytic hyperplasia is a rise in melanocyte number. It is critical to grasp this fundamental difference because it becomes a first consideration for categorizing melanonychia into its dominant types.

The differential diagnosis for LM is extensive. Benign causes are far more common than malignant ones and include physiologic factors such as ethnic pigmentation, drug-induced pigmentation, and benign melanocytic proliferations like lentigines and nevi #cite(<adigun_melanonychia_2024>, form: "normal"). According to @mio_establishment_2025, malignant causes are dominated by subungual melanoma, a subtype of acral lentiginous melanoma that accounts for 1-3% of all melanomas in predominantly white populations but can constitute up to 30% of cases in darker-skinned individuals. Other rare entities include squamous cell carcinoma of the nail matrix #cite(<lallas_seven_2023>, form: "normal") and onychopapilloma #cite(<bertanha_differential_2024>, form: "normal"). Furthermore, non-melanocytic sources such as subungual hematomas from trauma and pigmentary changes from fungal infections must be considered #cite(<ricardo_evaluation_2025>, form: "normal").

One example of a disease linked to melanonychia is observed by #cite(<dugan_management_2024>). In their study, they observed a nail abnormality called Acral lentiginous melanoma (ALM). They stated that Acral lentiginous melanoma (ALM) is the rarest of the four major subtypes of cutaneous melanoma, accounting for 2-3% of all melanomas. ALM occurs predominantly in non-hair-bearing skin of the distal extremities, such as the palms of the hands, soles of the feet, and nailbeds. This unique histologic subtype was first described by RJ Reed in 1976, as pigmented lesions with a radial (lentiginous) growth phase of melanocytes, which evolves into a dermal (vertical) invasive stage. In addition to its distinctive growth pattern, ALM has additional characteristics separating it from non-ALM cutaneous melanoma. ALM has a much lower mutational burden than non-ALM cutaneous melanomas, including a lower incidence of activating mutations in BRAF and NRAS, variable KIT mutations, and a lack of ultraviolet (UV)-related mutational signatures. Mechanical stress such as pressure and trauma may play a role in the development of advanced ALM, especially in the lower extremities, but studies have reported conflicting evidence of this potential association. Diagnosing ALM is clinically challenging because it can mimic benign conditions such as ulcers, diabetes-related lesions, warts, or trauma.

In a study conducted by @rodriguez-cerdeira_fungal_2024, infectious diseases, particularly those caused by specific fungi, can lead to a condition termed "fungal melanonychia," a rare variant of onychomycosis. This is caused by melanin-producing fungi, with Trichophyton rubrum (specifically the melanoid variant) being the most common culprit, accounting for 55% of cases. Other agents include Neoscytalidium dimidiatum (8%) and Fonsecaea pedrosoi. The pigmentation results from the deposition of a melanin-like substance produced by the fungus itself within the nail plate. Diagnosis often relies on direct examination and culture, and dermoscopy may show characteristic patterns like yellow-white spots or multicolor pigmentation.

Melanonychia is also one of the most common nail changes seen in people living with HIV/AIDS. One of the major findings by @flores-bozo_nail_2022 was longitudinal melanonychia is reported in about 25.3% of patients. A large portion of these cases (24.4%) are racial melanonychia, which matches the high percentage (70%) of participants with Fitzpatrick’s skin type IV. Aside from racial factors, longitudinal melanonychia is also linked to certain treatments. For example, one case (0.5%) was connected to the use of zidovudine, an antiretroviral drug. While combined antiretroviral therapy (cART) is effective in treating HIV, it can also increase the risk of both infectious and noninfectious nail conditions, including longitudinal melanonychia. Because these nail changes are common and can have different causes, regular nail checkups are important for people living with HIV.

Another nail classification that the researcher's models want to identify is Muehrcke’s Lines. In a study conducted by #cite(<mahajan_artificial_2024>), he stated that  Muehrcke’s lines appear as double white lines that run across the fingernails horizontally. Muehrcke’s lines usually affect several nails at a time. There are usually no lines on the thumbnails. Some characteristics of Muehrcke’s lines are: White bands go across the entire nail from side to side. Lines are usually most clearly seen on the second, third, and fourth fingers. The nail bed looks healthy in between the lines. The lines do not move as the nail grows. The lines do not cause dents in the nail. When you press down on the fingernail, the lines temporarily disappear.

The lines have been linked to low levels of a protein called albumin. Albumin is found in the blood. It is made in the liver. Although low albumin level is most commonly linked to liver disease, many different systemic (body-wide) diseases can cause low albumin levels. Muehrcke’s lines have been seen in people with: Cancer after chemotherapy; Kidney disease, including nephrotic syndrome and glomerulonephritis; Liver disease, including cirrhosis, an unbalanced diet that leads to an extreme lack of nutrients in the body #cite(<mahajan_artificial_2024>, form: "normal").

Onychogryphosis, also known as Ram's Horn Nail, is also identified by #cite(<mahajan_artificial_2024>). He stated that Onychogryphosis, also known as ram’s horn nail, is a nail disorder resulting from slow nail plate growth. Onychogryphosis is a nail disease that causes one side of the nail to grow faster than the other. It is characterized by an opaque, yellow-brown thickening of the nail plate with elongation and increased curvature. The nickname for this disease is ram’s horn nails because the nails are thick and curvy, like horns or claws.

Futher down the list of nail classification is pitting. Nail pitting may appear as depressions or dimples in your fingernails or toenails. Nail pitting may show up as shallow or deep holes in your nails. The pitting can happen on your fingernails or your toenails. You may think the pitting looks like white spots or other marks. It might even look like your nails have been hit with an ice pick. Nail pitting also may be related to alopecia areata---an autoimmune disease that causes hair loss. #cite(<mahajan_artificial_2024>, form: "normal")

Lastly, the researchers also included Terry's nails to nail classifications that the system is going to identify. According to #cite(<lin_development_2021>), terry’s nails are characterized by white opacification of the nails with effacement of the lunula and distal sparing. Described originally in 1954 by Dr. Richard Terry as a common fingernail abnormality in patients with hepatic cirrhosis, Terry’s nails are now a known sequelae of other conditions such as congestive heart failure, chronic kidney disease, diabetes mellitus, and malnutrition. Often all the nails of the hands are affected.

Correspondingly, #cite(<rowe_nail_2025>) states that Terry's nails are characterized by leukonychia of nearly the entire nail bed, with only the distal 1 to 2 mm possessing a normal color. They are most commonly associated with hepatic cirrhosis, and in one multicenter study of patients with cirrhosis, 25.6% had Terry's nails.

On top of that, while being promoted as one of the most reliable physical signs of cirrhosis and early sign of autoimmune hepatitis, Terry's nails can also be an indication of chronic renal failure, congestive heart failure, hematologic disease, adult-onset diabetes mellitus, but also occur with normal aging. #cite(<chiacchio_atlas_2024>, form: "normal")


=== Limitations of Traditional Diagnostics in Rural Areas
// NOTE: Might add more studies
Traditional diagnostic methods, particularly in rural areas, face several significant limitations related to equipment, expertise scarcity, inherent human variability, and the challenges of accurately interpreting complex symptoms. These limitations underscore a growing need for advanced artificial intelligence (AI) solutions in healthcare. In a study conducted by #cite(<nirupama_mobilenet-v2_2024>), they stated that access to dermatological expertise is limited, particularly in underserved or remote areas. Traditional methods of skin disease classification, although valuable, have their limitations. They heavily rely on human expertise, which leads to subjectivity and variations in diagnosis. In light of these challenges, there is a rising need for automated and computer-aided diagnostic systems to help dermatologists and healthcare providers in achieving more accurate and consistent results. In modern days, machine learning algorithms, especially deep models have shown promising outcomes in automating diagnostic procedures for skin disorders.

In addition, the study of #cite(<dhanashree_fingernail_2022>, form: "prose") mentions that though various diseases can be diagnosed using the colour of finger nails, the accuracy rate sometimes fails. This is mainly due to the colour assumptions made by humans through naked eye. The human eye has limitations in resolution and a small amount of colour change in a few pixels on a nail would not be highlighted to human eyes which may lead to wrong results whereas it is possible for a machine to recognize small colour changes on a nail. The health condition can be diagnosed using the nail’s thickness, length of nails, colour and texture.

=== Deep Learning and Image Processing for Nail Analysis
VGG-related networks like VGG-16 and VGG-19  are one of the highly cited families of CNNs in this context. They often appear as feature extractors or as initial point architectures due to their lightweight nature and proven capability on image classification datasets. For instance, @shandilya_autonomous_2024 proposed a dedicated four-block CNN yet compared it to VGG-19 that had 89.37% accuracy in recognizing six different nail disorders. Similarly, @marulkar_enhancing_2025 indicated that VGG-16 had 87.5% and 77% accuracies according to @ccaso_detection_2024 in separate classification tasks. More recent reports, however, indicate that although VGG-related models are still relevant, they are increasingly increasingly beaten by richer and deeper architectures. In one such work of @navarro-cabrera_machine_2025 targeting iron deficiency anemia, they noted that DenseNet169 had considerably outperformed VGG-16 in achieving 71.08% accuracy from a memory usage point of view compared to 64.77% for recall. The implication is thus that for particular subtle detection issues in medicine, possibly dense connectivity in DenseNets has something over sequential layering in VGGs.

The research conducted by #cite(<shandilya_autonomous_2024>, form: "prose") began with the development of a Base CNN model for nail disease classification and progressed to the creation of a more advanced Hybrid Capsule CNN model to improve classification performance. The integration of capsule networks into the Hybrid model significantly enhanced its ability to capture spatial hierarchies and handle transformations, leading to better overall classification outcomes. The Nail Disease Detection dataset has been employed to conduct the training and testing of both models. With an accuracy of 99.25%, the Hybrid Capsule CNN model provides a more accurate, robust, and dependable solution for automated nail disease classification than the Base CNN model with 97.75% accuracy. Its potential applications extend to medical diagnostics and healthcare automation, where accurate disease detection is critical for effective treatment.

Furthermore, #cite(<ardianto_bioinformatics-driven_2025>, form: "prose") explored the application of Convolutional Neural Networks (CNNs) to detect 17 classes of nail conditions, achieving an overall detection accuracy of 83%. The CNN model, configured with predefined parameters such as a dropout rate of 0.2 and a learning rate of 0.001, demonstrated strong generalization capabilities. Notably, the dropout rate effectively reduced overfitting by introducing regularization, while the learning rate balanced convergence speed and stability during training. These parameter choices were instrumental in achieving a low validation error (0.1037) compared to training error, highlighting the model's ability to generalize to unseen data. Certain classes, such as "Leukonychia" and "Splinter Hemorrhage," showed excellent detection accuracy due to well-defined visual patterns in these conditions. However, classes like "Pale Nail" and "Alopecia Areata" exhibited lower accuracy, indicating the need for additional data and refinement in feature extraction. This highlights the model's strengths while also identifying areas requiring further research. The results underscore the potential of using CNN models in medical applications, providing a rapid and accessible diagnostic tool for nail condition detection.

In the study conducted by #cite(<lahari_cnn_2023>, form: "prose"), two algorithms for classification namely Artificial Neural Network and Convolution neural network (DenseNet121) were used. The two algorithms are compared based on accuracy, specificity, and sensitivity. ANN is the older version which is less accurate. CNN is the latest model which can perform the classification better and it gives better results than ANN. CNN gives more accuracy and sensitivity than ANN. And the specificity is almost equal in both the algorithms. In their proposed technique, they trained a model that classifies the disease based on the colour and pattern of the nail. The system detects the diseases based on the features. It is able to identify the small patterns and colour variations also such that providing a system with higher success rate. Their proposed model gives more accurate results than human vision, because it overcomes the limitations of the human eye like to identify the variations in nail colour and patterns.

Furthermore, #cite(<sharma_fingernail_2024>, form: "prose") conducted a fingernail image-based health assessment using a hybrid VGG16 and Random Forest Model. The hybrid model has proven to be highly effective in classifying fingernail images into specific disease categories. The model's performance, evaluated through metrics such as accuracy, precision, recall, and F1-score, exceeded those of alternative classifiers. With a 97.02% accuracy rate, the proposed model shows great promise for early diagnosis of diseases such as kidney disorder, melanoma, and anemia through fingernail analysis. The proposed hybrid model has several advantages, including high accuracy and effective feature extraction through VGG16, making it highly reliable for disease detection. It is scalable, non-invasive, and versatile for other image-based diagnostics. However, its disadvantages include a limited dataset, and narrow disease focus. Future work can be focused on expanding the dataset, including more diseases, integrating the model into mobile applications, exploring advanced architectures like ResNet, and improving robustness to handle variable image quality for broader applicability.

Architectures from the ResNet family, particularly ResNet-50, have appeared extensively. They have been commended for their ability to train very deep networks by utilizing skip connections to alleviate vanishing gradients. Some studies have shown that ResNet-50 outperforms other well-known models. One comparative investigation of @marulkar_enhancing_2025 amongst various architectures across general nail disease classification claimed both ResNet50 and DenseNet201 had the highest precision at 96.39%, significantly outclassing VGG-16 at 87.5%.

The introduction of models such as EfficientNet exhibits a clear trend toward optimizing CNNs both in terms of power and efficiency. They are scaling networks that strive to balance depth, width, and resolution to achieve decent performance with fewer parameters. @can_diagnosing_2022 employed Noisy-Student weighted variants of EfficientNet-B2 to obtain 72% accuracy on a difficult multi-class classification task with 17 different diseases of nails. Then, @ebadi_jalal_abnormality_2025 extended this by proposing CE-NFCNet that is based on EfficientNet-B0 and consists of a cascade transfer learning method. Their network produced optimal results (1.00 precision, recall, accuracy, and AUC) by using a smaller image dataset that includes capillaroscopy of the nailfold. Their network dramatically outperformed models trained from scratch and single transfer learning. This illustrates how combining together EfficientNet with advanced learning techniques is very effective for dealing with special problems in medical imaging.

While CNNs are still by far the most common models, studies suggest that Vision Transformers (ViTs) are already making inroads. The self-attention associated with ViTs allows them to take in the whole image and look for global cues rather than having CNNs look at just minuscule local areas. @garaiman_vision_2022 utilized a predefined ViT to learn from images of nailfold capillaroscopy and diagnose microangiopathy from cases of systemic sclerosis with good results across several features. @roy_vision_2022 utilized a ViT to draw out features when they had to distinguish Yellow Nail Syndrome, yet another systemic condition. @garaiman_vision_2022 followed this up by creating a ViT model to help rheumatologists screen these changes and successfully illustrating it in a practical context. Though there are such successful examples, ViTs have not gained such popularity as CNNs. Most of the works are constructed on top of CNNs by virtue of their maturity and clarity, and transformers' contribution to analyzing images of nails is yet in development.

=== Probabilistic Modeling and Explainable AI
Bayesian methods and probabilistic modeling are becoming important in Explainable AI (XAI) because they can measure uncertainty and give clearer insights into how models make decisions. Recent studies highlight the strengths of Bayesian methods for making AI more interpretable, especially in critical areas where it is essential to understand how and why AI systems reach their conclusions.

A review by @zhou_combining_2025 notes that Bayesian inference has many advantages in decision making of agents (e.g. robotics/simulative agent) over a regular data-driven black-box neural network: Data-efficiency, generalization, interpretability, and safety where these advantages benefit directly/indirectly from the uncertainty quantification of Bayesian inference. In the same way, another analysis of Bayesian applications explains that their probabilistic outputs provide valuable insights not just into the “what” of a prediction, but also the “why.” Decision-makers can assess the confidence of predictions, making the entire model more transparent and trustworthy #cite(<ma_advances_2021>, form: "normal"). This connects directly to the main goal of XAI, which seeks to clarify complex model decisions, making them more transparent and understandable to users, an aim that is especially important in sectors like healthcare and finance, where understanding the reasoning behind model decisions is essential for trust, adoption, and ethical application #cite(<hsieh_comprehensive_2024>, form: "normal").

A major strength of combining probabilistic methods with XAI is their ability to measure uncertainty, something that most deep learning models struggle to do. While deep neural networks are powerful in representing patterns, most models struggle to meet practical requirements for uncertainty estimation, and their entangled nature leads to a multifaceted problem, where various localized explanation techniques reveal that multiple unrelated features influence the decisions, thereby undermining interpretability #cite(<hu_enhancing_2024>, form: "normal"). By comparison, probabilistic neural networks, such as those utilizing variational inference, address this limitation by incorporating uncertainty estimation through weight distributions rather than point estimates #cite(<bera_quantification_2025>, form: "normal"). In fact, Bayesian models, with their inherent uncertainty quantification, are well-suited for applications that require explainable AI, making them a promising avenue for future research #cite(<phdprima_research_ai_2025>, form: "normal"). This is important because desirable properties like adequate calibration, robustness, explainability, and interpretability are often lacking in many deep learning systems #cite(<leeuwen_uncertainty_2024>, form: "normal").

Understanding the detailed results of Bayesian inference is still difficult, especially when working with complex models. For instance, in Bayesian cluster analysis, the method is appreciated because it can provide uncertainty in the partition structure. However, summarizing the posterior distribution over the clustering structure can be challenging, due to the discrete, unordered nature and massive dimension of the space #cite(<balocchi_understanding_2025>, form: "normal"). This shows that even though Bayesian methods give useful information about uncertainty, better tools are needed to make these complex probabilistic results easier to interpret.

Probabilistic programming languages (PPLs) are seen as an important tool for making Bayesian models easier to understand. They provide structured ways to represent models and allow automated inference. PPLs make it easier to build complex Bayesian models by offering automatic inference via practical and efficient Markov Chain Monte Carlo (MCMC) sampling #cite(<ito_what_2023>, form: "normal"). This helps researchers explore both prior and posterior distributions, which is important for understanding a model’s parameters and predictions.

Beyond general interpretability, probabilistic methods are also used for attribution, which measures how much each input or factor contributes to an outcome under uncertainty. For example, #cite(<rodemann_explaining_2024>) introduce ShapleyBO, a framework for interpreting BO's proposals by game-theoretic Shapley values to quantify each parameter's contribution to BO's acquisition function. They explain that ShapleyBO can disentangle the contributions to exploration into those that explore aleatoric and epistemic uncertainty #cite(<rodemann_explaining_2024>, form: "normal"). In a similar direction, #cite(<li_shapley_2023>) propose a probability-based Shapley (P-Shapley) value, which uses predicted probabilities to better separate the importance of different data points in machine learning classifiers. From an economics perspective, #cite(<sinha_bayesian_2022>) present a Bayesian model of marketing attribution that not only captures known effects of advertisements but also provides usable error bounds for parameters of interest.

Measuring posterior uncertainty is also vital for improving models and making reliable decisions, especially with unclear data. In behavioral science, earlier attempts to automate aspects typically have limited interpretability and lack uncertainty representation, which increases the risk of hidden errors #cite(<hayden_uncertainty_2021>, form: "normal"). On the other hand, using posterior uncertainty to identify ambiguities in observed data and automatically schedule sparse human annotations can rapidly improve posterior estimates and reduce uncertainty #cite(<hayden_uncertainty_2021>, form: "normal"). This shows how Bayesian approaches, with their strong focus on uncertainty, create AI systems that are more reliable and flexible, which is especially useful when collecting data is costly or requires expert knowledge.

=== Clinical Applications
The use of deep learning on fingernail biomarkers has grown a lot since 2021. Researchers are no longer just classifying nail images but are now focusing on detecting different systemic diseases. Recent studies show strong results in spotting nail changes linked to conditions like anemia, liver disease, and nutritional problems. A common trend is the use of transfer learning with well-known models such as VGG-16 #cite(<sharma_fingernail_2024>, form: "normal") and DenseNet #cite(<alzahrani_deep_2023>, form: "normal"). These are often paired with traditional machine learning methods to create hybrid models that perform with higher accuracy. For example, @cosar_sogukkuyu_classification_2023 built a model with VGG-16 that classified three nail diseases: Beau’s lines, melanonychia, and clubbing, from 723 clinical images, reaching 94% accuracy. In another study, @hadiyoso_classification_2022 applied VGG-16 with transfer learning to classify koilonychia, Beau’s lines, and leukonychia, achieving 96% accuracy.

Many studies have focused on iron deficiency anemia, which is closely linked to koilonychia (spoon-shaped nails). @navarro-cabrera_machine_2025 carried out a study using 909 fingernail images captured with a smartphone to detect anemia with deep learning. Their DenseNet169 model achieved a 71.08% test accuracy, showing that this method can work in young adult university populations. Another unique study used metabolomics. @zhang_fingernail-based_2025 found that levels of dodecanoic acid in fingernails declined step by step with Alzheimer’s disease progression. This suggests nails could also serve as a non-invasive biomarker for neurodegenerative diseases. While this was not about nail shape, it shows the potential of studying the chemical makeup of nails to detect systemic diseases.

Beyond detecting just one disease, there is growing interest in screening for multiple health problems at once. @sharma_fingernail_2024 used a hybrid deep learning model that could classify images into three groups: kidney disorder, melanoma, and anemia. This shows the potential for one system to check for several conditions at the same time. Another new approach is combining clinical data, like patient history or lab results, with image features, since this extra context can improve diagnosis. Still, many current models rely only on images, which may limit their accuracy compared to models that also use medical background information #cite(<jeong_deep_2022>, form: "normal"). Even with these improvements, big challenges remain. These include the lack of large, open, and clinically tested datasets, the difficulty of understanding how models make decisions, and the need for strong real-world testing before these tools can be used in everyday medical practice #cite(<kandekar_deep_2025>, form: "normal") #cite(<gaurav_artificial_2025>, form: "normal").

While the main goal is to screen for systemic diseases, deep learning models are also being trained to focus on specific nail problems. These smaller studies often serve as the foundation for bigger diagnostic systems and show how AI can recognize patterns. Other studies have built highly accurate models for many conditions, ranging from minor cosmetic changes to serious cancers. The best results usually come from fine-tuning pre-trained networks with special datasets designed for certain nail disorders. This lets the models pick up on small visual details that define each condition.

One major area of progress is the automated classification of nail disorders. For example, @ardianto_bioinformatics-driven_2025 created a CNN model that could classify 17 types of nail diseases, including Beau’s lines, Bluish Nail, Koilonychia, and Muehrcke’s lines. The model reached an overall accuracy of 83%. It was especially strong at recognizing clear conditions like Splinter Hemorrhage and Muehrcke’s lines, where it correctly identified all test samples. This shows that deep learning can even detect rare conditions. Similarly, @shandilya_autonomous_2024 designed a Hybrid Capsule CNN that classified six nail disorders, such as Blue Finger and Acral Lentiginous Melanoma, with an impressive 99.25% validation accuracy. This model performed better than a standard CNN because it could maintain spatial features. In another study, @tolani_human_2025 improved the MobileNetV2 model to classify 17 nail conditions, such as Beau’s lines, alopecia areata, and yellow nails. They highlighted how data augmentation techniques helped make the model more reliable.

Detecting subungual melanoma, a dangerous type of skin cancer, is another important use case. @gaurav_artificial_2025 reported that while some CNNs could detect melanonychia, their sensitivity for melanoma was only 53.3%, showing that much improvement is needed. More recent studies worked on solving this issue. @chen_development_2022 introduced an interpretable U-Net segmentation model for dermoscopic nail images. It achieved a Dice score of 96.52% for nail plate segmentation and 87.11% for pigmented spot segmentation. By adding a rule-based module that links model outputs to clinical standards, their system gave dermatologists clear guidance for biopsies and follow-ups of suspicious lesions. This marks a move from simple classification to explainable and practical clinical decision support.

Other conditions have also been studied with deep learning. @pujari_real_2025 used the YOLOv8 object detection model to spot onychomycosis (fungal infection), melanonychia, leukonychia, and paronychia with high precision and recall. Object detection works well here because these issues often appear as visible spots or patches. For nail psoriasis, a long-term inflammatory disorder, AI tools now help assess disease severity automatically. @folle_deepnapsi_2023 developed a system to predict the modified Nail Psoriasis Severity Index (mNAPSI) score, which showed a strong match with expert ratings, while @hsieh_mask_2022 applied Mask R-CNN to detect features like nail pitting and oil-drop discoloration, reaching an average accuracy of 91.5%. These tools can save doctors time and provide more consistent ways to track treatment progress. Altogether, the progress in detecting specific nail conditions shows how flexible deep learning can be. It is becoming a valuable tool for both dermatologists and primary care doctors in diagnosing a wide range of nail-related diseases.

The fast growth of deep learning for fingernail biomarkers comes from many different methods and model designs. Researchers use several types of neural networks, ranging from standard Convolutional Neural Networks (CNNs) to newer transformer-based models. Since most nail datasets are small, transfer learning is often used to get around the lack of training data. The choice of model depends on the task, such as classification, segmentation, or object detection, and shows how the field is improving at finding useful features in complex nail images.

Transfer learning is now the most common strategy for making clinical diagnostic models. In this approach, a pre-trained model like VGG16, ResNet50, or DenseNet201 is first trained on a huge dataset like ImageNet, and then adjusted to work on a smaller set of nail images #cite(<kandekar_deep_2025>, form: "normal") #cite(<jeong_deep_2022>, form: "normal"). This process improves accuracy and shortens training time compared to building a model from scratch. Several studies, including those by @abdulhadi_human_2021, @cosar_sogukkuyu_classification_2023, and @hadiyoso_classification_2022, successfully applied transfer learning to classify nail diseases such as hyperpigmentation, clubbing, and Beau’s lines with high accuracy. Another important step forward is hybrid models, which combine deep learning for feature extraction with traditional machine learning for classification. For example, @sharma_fingernail_2024 used VGG16 for feature extraction and Random Forest for classification, reaching 97.02% accuracy in detecting multiple nail diseases. Likewise, @alzahrani_deep_2023 used DenseNet201 with an SGDClassifier and achieved 94% accuracy. These results show that the best solutions do not always come from deep learning alone.

For tasks that require marking exact regions in an image, such as highlighting pigmented areas or outlining nail features, segmentation models like U-Net and Mask R-CNN work very well. @chen_development_2022 built a U-Net-based model to segment dermoscopic nail images. The model had high Dice scores and helped track pigmented lesions more precisely, which is important for early melanoma detection. @hsieh_mask_2022 used Mask R-CNN to both segment and classify nail psoriasis signs like pitting and onycholysis, achieving strong accuracy and proving the usefulness of instance segmentation in dermatology. Object detection models, such as YOLOv8, are also becoming popular for spotting nail conditions in larger images. For example, @pujari_real_2025 used YOLOv8 to detect onychomycosis, melanonychia, and other diseases from nail images with high precision and recall.

New types of deep learning models, like Capsule Networks and Vision Transformers (ViTs), are also being studied. @shandilya_autonomous_2024 created a Hybrid Capsule CNN model that performed better than a regular CNN in classifying different nail disorders. This shows that keeping the layered relationships between features can be helpful. ViTs are also seen as a strong option for image classification and segmentation because they can capture long-range patterns in an image #cite(<kandekar_deep_2025>, form: "normal") #cite(<gaurav_artificial_2025>, form: "normal"). Many studies also rely on data augmentation methods, like rotation, flipping, zooming, and brightness changes. These methods are important for avoiding overfitting and improving how well models work on small datasets #cite(<shandilya_autonomous_2024>, form: "normal") #cite(<cosar_sogukkuyu_classification_2023>, form: "normal") #cite(<tolani_human_2025>, form: "normal").

Even though deep learning for fingernail biomarkers has shown good progress, there are still many problems that need to be solved before it can be used in real clinical and forensic settings. The biggest challenge is the lack of large, public, and clinically approved datasets. Most research today uses small private datasets from places like Kaggle or from local collections, which makes it hard to create models that work well in different situations. This problem, often called the “private dataset problem,” means that a model trained on one group of images might not perform well when tested with images from another clinic, camera, or group of people. A review by @kandekar_deep_2025 pointed this out directly, saying that poor data diversity and weak generalization are major issues for real-world use.

Another problem is that many deep learning models act like a “black box,” which means they are hard to interpret or explain. Doctors may not trust a diagnosis from a model they cannot fully understand. To fix this, researchers are working on Explainable AI (XAI), which makes models easier to interpret. For example, @chen_development_2022 designed a U-Net model with a rule-based system that connects its outputs to clinical parameters. @folle_deepnapsi_2023 also showed strong correlation between their AI-generated mNAPSI scores and human ratings, making their results more trustworthy. Without clear explanations, it will be difficult for these models to gain approval from regulators or acceptance from clinicians.

Lastly, many models have not been properly validated. A lot of studies are still at the proof-of-concept stage and have not been tested on independent datasets. When validation does happen, it is often done using old stored data instead of testing in real clinical environments. On top of that, there are no standard rules for how to collect images, process data, or report results, which makes it hard to compare different studies or perform meta-analysis. Another gap is the lack of forensic applications, since no studies have yet tested deep learning on nail biomarkers in that field. Solving these challenges will take teamwork across the research community to create stronger, fairer, and more transparent systems.

=== Lightweight AI for Rural Deployment
Lightweight AI has been used to bring advanced medical testing to rural areas. @guo_smartphone-based_2021 created a smartphone-based system for diagnosing malaria. The platform combines a low-cost paper DNA test with a deep learning classifier that runs directly on the phone. This all-in-one setup can analyze samples and give instant results without needing internet access. In field tests in rural Uganda, the system correctly identified more than 98% of malaria cases. By using deep neural networks designed for mobile devices, the researchers made it possible to deliver lab-quality diagnosis with just a handheld phone #cite(<guo_smartphone-based_2021>, form: "normal"). This study shows that combining simple physical tests with on-device AI can fill important gaps in rural healthcare. The system still requires special test strips and a trained user to run the test, but it proves that AI can be used for local decision support and even share secure health data through blockchain for tracking diseases.

In another case, @abdusalomov_accessible_2025 worked on brain tumor detection by creating a lightweight object-detection network for MRI images. Instead of the usual ResNet backbone in RetinaNet, they used MobileNet and depthwise separable convolutions, which made the model smaller and easier to run on portable devices. Even with this simpler design, their version of RetinaNet achieved an average precision ($"AP"$) of 32.1% on the BRATS dataset. It performed better than larger models at finding both small tumors ($"AP"_S = 14.3$) and large tumors ($"AP"_L = 49.7$). Most importantly, this lighter model reduces computational cost, making real-time MRI analysis possible on low-power hardware. The authors highlight that their design can detect tumors in different cases with high accuracy (scores >81%), which could help expand access to brain scans in underfunded clinics. They also mention, however, that the model has only been tested on benchmark datasets, not yet in live hospitals.

Both @guo_smartphone-based_2021 and @abdusalomov_accessible_2025 show how simplifying AI models and running them directly on devices can bring powerful medical tools to rural healthcare. At the same time, challenges remain, such as hardware compatibility and more clinical testing.

Another common and practical way to build models that save resources is to use large pre-trained deep learning models without fully retraining them. This method is known as transfer learning. It works by using powerful Convolutional Neural Networks (CNNs) as feature extractors. In a study by @isewon_optimizing_2025, they tested this method by using popular CNNs such as VGG-16, ResNet-50, and EfficientNet-B0 to pull out important features from medical images. These features were then used as inputs for simpler machine learning models, such as Logistic Regression (LR), Random Forests, and Naïve Bayes #cite(<isewon_optimizing_2025>, form: "normal").

The study found that this mix of deep CNNs and shallow models creates a good balance between strong prediction performance and efficiency. For example, when a simple LR model was trained on features extracted by VGG-16, it reached almost the same accuracy as a fully trained VGG-16 model for classifying medical images. The key difference was that it used far less time and memory, making it more practical for devices with limited processing power #cite(<isewon_optimizing_2025>, form: "normal").

This type of "adaptation" works well because it takes advantage of features already learned by large models trained on huge datasets. It is also faster to apply and comes with fewer risks. Still, there are some limits. The study pointed out that performance gains were smaller when the method was applied to very imbalanced datasets, which are common in medical data. Another issue is that the final performance of the shallow models depends heavily on the quality of the features learned by the original CNN. Since many of these CNNs were trained on general image datasets like ImageNet and not on medical data, this can restrict how effective the method is #cite(<isewon_optimizing_2025>, form: "normal").

Other studies use more direct ways to make models smaller and faster. This can be done by shrinking large models or by designing new ones that are efficient from the start. @musa_lightweight_2025 created a detailed review of model compression methods. These include pruning, which means removing extra or unimportant neural connections or filters from a trained network; quantization, which lowers the precision of a model’s weights (for example, turning 32-bit floating-point numbers into 8-bit integers) to make the model smaller and faster; and knowledge distillation, where a smaller "student" model is trained to copy the results of a larger "teacher" model. These methods can cut down model size and speed up computation, but they often come with a trade-off: the more you compress, the higher the chance of losing accuracy #cite(<musa_lightweight_2025>, form: "normal").

The "Innovation" pathway takes a different route by creating lightweight models from the ground up. Although this approach requires more effort during design, it can lead to models that are both powerful and efficient. Recent studies show good results from custom shallow CNNs. For instance, the MNet-10 model has only 10 layers but still achieved high accuracy in multiple medical imaging tasks #cite(<montaha_mnet-10_2022>, form: "normal"). @singh_healthcare_2024 also created EO-LWAMCNet, a lightweight CNN made for Internet of Things (IoT) devices. It achieved about 95% accuracy in predicting chronic liver and brain diseases from sensor data. Because it is efficient, this model allows advanced diagnostics without needing expensive local hardware #cite(<singh_healthcare_2024>, form: "normal").

Current research is also exploring new hybrid designs that mix different architectures. One example is MUCM-Net, which was made for skin lesion segmentation. It combines the spatial feature extraction of CNNs, the pattern recognition strengths of Multi-Layer Perceptrons (MLPs), and modern state-space models (Mamba) #cite(<yuan_mucm-net_2024>, form: "normal"). The result is a model that is both highly accurate (with a Dice Similarity Coefficient of $0.91$) and very efficient, requiring only $0.055$ GFLOPS. This makes it a great choice for mobile devices in areas with limited resources #cite(<yuan_mucm-net_2024>, form: "normal"). Another example is the lightweight CNN made by @vincent_performance_2025 for skin cancer detection. It was designed with mobile-first use in mind and was tested on low-cost devices like the Raspberry Pi and NVIDIA Jetson Nano using TensorFlow Lite. The system reached 98.25% accuracy and ran in just 0.01 seconds on a Raspberry Pi 5, showing that it is possible to build fast, offline, and affordable diagnostic tools #cite(<vincent_performance_2025>, form: "normal").

Most research on lightweight diagnostic AI, especially for areas with limited resources, focuses on medical image analysis. Common examples include skin lesion checks in dermatology, X-rays and CT scans in radiology, and retinal scans in ophthalmology. However, there is still a big gap in using these resource-efficient deep learning methods on other types of data that are easier to access, non-invasive, and low-cost. One promising but less studied option is the use of fingernail images. Fingernails contain shape and color features, known as biomarkers, that can be captured with regular consumer cameras. These features could help in the probabilistic detection of systemic diseases.

=== Synthesis
The related studies literature registers a strong need for non-invasive and easy-to-use diagnostic devices, most importantly in rural and disadvantaged areas where professionals are hard to reach #cite(<prajeeth_smart_2023>, form: "normal") #cite(<alruwaili_integrated_2025>, form: "normal"). Prior research mentions that nails may serve a potential source of health information. Several studies link nail changes such as clubbing, koilonychia, cyanosis, Terry’s nails, etc., to acute medical conditions such as heart and pulmonary disorders, liver cirrhosis, iron deficiency anemia, etc. #cite(<shandilya_autonomous_2024>, form: "normal") #cite(<abdulhadi_human_2021>, form: "normal") #cite(<desir_nail_2024>, form: "normal").

The literature also reveals that deep learning has indeed been effective to detect nail conditions from images, strengthening the current approach taken by this study. Architectures such as VGG16, ResNet50, and EfficientNet are found to work well in other related studies, and so are appropriate choices to train and test in this study #cite(<ardianto_bioinformatics-driven_2025>, form: "normal") #cite(<sharma_fingernail_2024>, form: "normal") #cite(<han_deep_2018>, form: "normal"). Data enhancement is similarly presented to be a valuable step to increase model consistency, and this is in alignment with the researchers’ objective to enhance their dataset.

The literature mentions two major gaps that this work is eager to address. Firstly, there is the “black box” issue, where deep learning models are correct but are not transparent enough to help doctors trust them #cite(<kandekar_deep_2025>, form: "normal") #cite(<hsieh_comprehensive_2024>, form: "normal"). To address this, the study will make use of Bayesian inference and a hand-curated dataset to calculate the chances of diseases. This facilitates the system to transition from merely image classification to outputting clearer, probabilistic health information and injects a degree of transparency and uncertainty that is lacking in current models #cite(<zhou_combining_2025>, form: "normal") #cite(<ma_advances_2021>, form: "normal"). The second gap is that most current work reaches only to proof-of-concept and does not progress to real-world deployment or testing #cite(<kandekar_deep_2025>, form: "normal") #cite(<gaurav_artificial_2025>, form: "normal"). This study will fill that gap by developing a working prototype application from the highest-performing model. This step is critical to converting theoretical performance to a practical aid to clinical decision-making.

This study brings together the strengths of deep learning and the explainability of a Bayesian approach to improve current diagnostic tools. The process covers everything from collecting data and training the model to creating a working prototype. The goal is to build a complete system that is non-invasive and affordable. In the long run, the aim is to move from theory to real-world use by providing a reliable health screening tool, especially for communities that need it most.

#pagebreak()
#metadata("Chapter 2 end") <ch2-e>

#metadata("Chapter 3 start") <ch3-s>
#chp[Chapter III]
#h2(outlined: false, bookmarked: false)[Research Methodology]

This chapter presents the methods and materials the researchers used to fulfill the objectives. It covers the research design, locale of the study, applied concepts and techniques, algorithm analysis, data collection methods, system development methodology, software tools used, system architecture and software testing


=== Research Design
This study adopts a quantitative research approach, emphasizing measurable outcomes and statistical evaluation of model performance. The research is both experimental and developmental in nature. The experimental aspect involves testing and evaluating various deep learning architectures on an augmented dataset of fingernail images. The developmental component focuses on the design and implementation of an intelligent system that integrates image classification and probabilistic inference to detect systemic diseases based on nail biomarkers.

Through systematic experimentation, model benchmarking, and iterative improvement, the study aims to determine the most effective neural network architectures for the classification task and integrate them into a functional web-based application for real-world use.

=== Locale of the Study
This study was conducted at Laguna State Polytechnic University Santa Cruz Campus, a state university located in the province of Laguna, Philippines. The study focuses on the probabilistic detection of systemic diseases using deep learning on fingernail biomarkers, aiming to develop an application that enables early health risk screening. Conducting the research at LSPU ensures access to necessary tools and academic supervision.

The primary beneficiaries of this study are individuals seeking preventive healthcare in a convenient, accessible form. By designing the system to be user-friendly and deployable on digital platforms, the research addresses the growing demand for proactive health monitoring solutions. This includes not only residents of Sta. Cruz, Laguna and nearby areas but also any users with internet access who want to perform preliminary health assessments on the go.

Moreover, the research may serve as a valuable reference for future researchers, healthcare stakeholders, and technology developers interested in AI-driven solutions for early disease detection. By grounding the study in a local academic institution and addressing global health accessibility concerns, the project aims to contribute meaningfully to both scientific literature and real-world healthcare practices.

=== Applied Concepts and Techniques
This study integrates a wide range of machine learning and software engineering techniques to develop a reliable, scalable system for the probabilistic detection of systemic diseases through nail image classification. The applied concepts are grouped thematically to emphasize their specific roles in the system development lifecycle.

==== Machine Learning
According to #cite(<geeksforgeeks-2025a>), machine learning is a branch of artificial intelligence that enables algorithms to uncover hidden patterns within datasets. It allows them to predict new, similar data without explicit programming for each task.

In this study, the researchers utilized machine learning to detect subtle to distinct nail changes. These nail features, such as discoloration for blue nails and shape abnormalities for clubbing, can be difficult to interpret using rule-based methods or traditional programming techniques. By using machine learning, particularly deep learning models, the system can learn to recognize patterns in nail images without explicitly programming what each nail feature would look like.

#figure(image("img/machine-learning-geek-for-geeks.png"), caption: flex-caption(
  [Machine Learning #cite(<geeksforgeeks-2025a>, form: "normal")],
  [Machine Learning],
)) <machine-learning>

@machine-learning shows how machine learning models work. The model takes in inputs like stock data, customer transaction data, streaming data, and email text. It is then put into machine learning algorithms and techniques such as regression for numerical data and classification for categorical data where the model learns patterns in the data. Lastly, the output represents the model's prediction of the expected outcome based on the patterns it has learned from the training data.

==== Supervised Machine Learning
According to #cite(<geeksforgeeks-2025b>), supervised machine learning is a fundamental approach for machine learning and artificial intelligence. It involves training a model using labeled data, where each input comes with a corresponding correct output. Supervised machine learning can be applied to two main types of problems: classification and regression.

This study involves a classification problem and falls under the category of supervised machine learning. The model is trained on labeled data which are nail images paired with corresponding nail disease labels. Then it learns to classify new, unseen nail images into their respective categories based on learned features.

#figure(image("img/supervised-machine-learning-geek-for-geeks.png"), caption: flex-caption(
  [Supervised Machine Learning #cite(<geeksforgeeks-2025b>, form: "normal")],
  [Supervised Machine Learning],
))<supervised>


@supervised illustrates how supervised learning works. The input data contains data that are labeled. Each labeled data is then fed into the algorithm. The algorithm learns the associations and patterns between the data and its label. It finds out what patterns likely lead to each label. Finally, the model predicts labels based on inputs.


==== Neural Networks
According to #cite(<ibm-2025a>), a neural network is a machine learning program, or model, that makes decisions in a manner similar to the human brain, by using processes that mimic the way biological neurons work together to identify phenomena, weigh options and arrive at conclusions.

In this study, the researchers utilized neural networks because of their strong ability to detect complex patterns in data like images of nails. Unlike traditional machine learning algorithms that often require manual feature extraction, neural networks can automatically learn hierarchical representations of features like color and texture by analyzing images pixel by pixel.

#figure(image("img/neural-networks-geeks-for-geeks.png"), caption: flex-caption(
  [Neural Network Architecture #cite(<geeksforgeeks-2025c>, form: "normal")],
  [Neural Network Architecture],
)) <neural-network>

@neural-network shows the architecture of a neural network. The figure is from #cite(<geeksforgeeks-2025c>) and illustrates that every neural network consists of layers of nodes or artificial neurons, an input layer, one or more hidden layers, and an output layer. Each node connects to others, and has its own associated weight and threshold. If the output of any individual node is above the specified threshold value, that node is activated, sending data to the next layer of the network. Otherwise, no data is passed along to the next layer of the network.

==== Deep Learning
Deep learning is a subset of machine learning that uses multilayered neural networks, called deep neural networks, to simulate the complex decision-making power of the human brain #cite(<holdsworth-2025>, form: "normal").

According to #cite(<ibm-2025a>), deep learning and neural networks tend to be used interchangeably in conversation, which can be confusing. It is important to note that the term “deep” in deep learning refers specifically to the number of layers within a neural network. A neural network with more than three layers, including the input and output layers, is typically classified as a deep learning algorithm. In contrast, networks with only two or three layers are considered basic neural networks.

The neural networks used in this study are considered deep neural networks, since images of nails are very complex and have variations such as texture, color, and spatial patterns, which will require multiple hidden layers to effectively extract and learn these features for accurate classification.

#figure(image("img/deep-neural-network-ibm.png"), caption: flex-caption(
  [Deep Neural Network Architecture #cite(<ibm-2025a>, form: "normal")],
  [Deep Neural Network Architecture],
)) <dnn>


@dnn shows the architecture of a deep neural network. Unlike basic neural networks, deep neural networks consist of many more hidden layers. Machine learning on these deep neural networks is called deep learning.

==== Convolutional Neural Networks
According to #cite(<ibm-2025b>), convolutional neural networks are distinguished from other neural networks by their superior performance with image, speech or audio signal inputs. They have three main types of layers, which are the convolutional layer, pooling layer, and fully-connected (FC) layer.

This nature of superior performance in images is the primary reason the researchers chose this type of neural networks. Convolutional neural networks are particularly well-suited for visual recognition tasks due to their ability to capture spatial hierarchies and local dependencies in images. The convolutional layers automatically learn relevant patterns such as edges, textures, and shapes, while deeper layers can abstract more complex features like structures or the anomalies present in the nail photos.

#figure(image("img/cnn-developer-breach.png"), caption: flex-caption(
  [Convolutional Neural Network Architecture #cite(<ibm-2025b>, form: "normal")],
  [Convolutional Neural Network Architecture],
))<cnn>

@cnn illustrates the architecture of a CNN, which consists of two primary components: feature extraction and classification. The input image is processed through a series of convolutional layers with ReLU activation, followed by pooling layers that progressively reduce spatial dimensions while retaining important features. These operations generate hierarchical feature maps that capture visual patterns from the image. The output of the feature extraction stage is then flattened and passed through fully connected layers, which act as the classification component. Finally, a softmax activation function produces a probabilistic distribution over predefined classes, enabling the model to make predictions based on the learned features.

All the CNNs used in this study follow this same fundamental procedure, only having differences in depth and complexity of their architecture like the number of convolutional and pooling layers, the size and the number of filters, and the structure of the fully connected layers.

==== Vision Transformers
According to #cite(<shah-2022>), in ViTs, images are represented as sequences, and class labels for the image are predicted, which allows models to learn image structure independently. Input images are treated as a sequence of patches where every patch is flattened into a single vector by concatenating the channels of all pixels in a patch and then linearly projecting it to the desired input dimension.

The researchers considered testing ViTs due to their ability to model global relationships across an image rather than relying on local feature extractions. The researchers explored whether the unique architecture of ViTs can offer advantages over CNN models in classifying nail features. Testing it allowed researchers to compare performance, generalization, and representation against CNNs, contributing to a more comprehensive evaluation of model effectiveness. Vision Transformers generally perform better than CNNs, so the researchers considered using it. However, they are more computationally expensive and harder to interpret, so it's a matter of trade-offs.

#figure(image("img/vit-geek-for-geeks.png"), caption: flex-caption(
  [Architecture and Working of Vision Transformers #cite(<geeksforgeeks-2025d>, form: "normal")],
  [Architecture and Working of Vision Transformers],
)) <vit>

@vit shows the architecture of ViTs. The figure is from #cite(<geeksforgeeks-2025d>). The input image is divided into patches which are flattened and embedded using linear projection. Positional encodings are then added to the patch embeddings to retain spatial information. The patch embeddings are passed through multiple transformer encoder layers, which include multi-head self-attention and feed-forward networks. Lastly, the CLS token's output is extracted and fed into Multi-Layer Perceptrons (MLP) for the final classification.

==== Transfer Learning
According to #cite(<murel-jacob-2025a>), transfer learning uses pre-trained models from one machine learning task or dataset to improve performance and generalizability on a related task or dataset.

#figure(image("img/transfer-learning.png"), caption: flex-caption(
  [Transfer Learning #cite(<kaya-2022>, form: "normal")],
  [Transfer Learning],
)) <transfer-learning>

The researchers utilized and made use of transfer learning to gain several advantages in training. It helped the researchers reduce computational costs like model training time and training data. Using transfer learning also helps improve generalizability because it involves retraining an existing model with a new dataset, and the re-trained model will consist of knowledge gained from multiple datasets. In this case, the pre-trained models from `torchvision` were trained on ImageNet, enabling the model to benefit from features that were already learned from a wide range of images in ImageNet.

==== Fine-Tuning
Fine-tuning and transfer learning are related but distinct techniques. According to #cite(<murel-jacob-2025a>), while both approaches involve reusing pre-existing models instead of training from scratch, they differ in how the pre-trained models are adapted. Transfer learning typically involves using the pre-trained model as a fixed feature extractor by freezing its weights and training only a new classifier layer on top. In contrast, fine-tuning refers to unfreezing part or all of the pre-trained model and continuing the training process on a new, task-specific dataset. This allows the model to adapt its internal representations to better fit the characteristics of the target domain.

In the researchers case, they further trained pre-trained models on their nail dataset. This was done to allow the model to refine general visual features it learned from Imagenet and adapt them to visual cues present in nail images.

==== Multiclass Classification
Multiclass classification is a machine learning classification task that consists of more than two classes, or outputs #cite(<data-robot-2025>, form: "normal"). In this study, the researchers adopted a multiclass classification approach because there are a total of 10 distinct classes of nail features in their dataset. The model is trained to identify which specific nail feature is present in a given input image. Since each image belongs to only one category and the task requires distinguishing among multiple possibilities, multiclass classification was the appropriate and necessary framework.

#figure(image("img/multiclass-classification.png"), caption: flex-caption(
  [Multiclass Classification #cite(<kainat-2023>, form: "normal")],
  [Multiclass Classification],
)) <multiclass-classification>

@multiclass-classification shows an example of an illustration of multiclass classification. Each shape is its own label or class. In this illustration, the model would take an image of an object as input and predict one of the three possible classes which are "triangle", "cross", or "circle", to which the object belongs.

==== Image Preprocessing
According to #cite(<geeksforgeeks-2025e>), image preprocessing is a crucial step that involves transforming raw image data into a format that can be effectively utilized by machine learning algorithms. Proper preprocessing can significantly enhance the accuracy and efficiency of image recognition tasks.

In this study, the researchers applied image preprocessing techniques in order to transform images to numbers or tensors, since machine learning and deep learning models only understand numbers, and not images. The preprocessing steps applied in this study are resizing, normalization, and conversion of image to tensors.

==== Image Normalization
Normalization adjusts pixel intensity values to a standard scale #cite(<geeksforgeeks-2025e>, form: "normal"). In this research, input images were normalized using the standard ImageNet mean and standard deviation values: $"mean" = [0.485, 0.456, 0.406]$ and $"std" = [0.229, 0.224, 0.225]$. This normalization ensures compatibility with pre-trained models from PyTorch’s torchvision library, which were originally trained on the ImageNet dataset. By aligning the data distributions, normalization enables more effective transfer learning and stable gradient flow during training.

==== Data Augmentation
According to #cite(<murel-jacob-2025b>), data augmentation uses pre-existing data to create new data samples that can improve model optimization and generalizability. It improves machine learning model optimization and generalization. In other words, data augmentation can reduce overfitting and improve model robustness.

In this research, the dataset was subjected to various image augmentation techniques, including flipping, shearing, rotation, brightness adjustment, and exposure modification. These augmentations enable the model to learn from diverse orientations, lighting conditions, and perspectives of the nail images, thereby enhancing its ability to generalize to unseen data.

#figure(image("img/data-augmentation.png"), caption: flex-caption(
  [Image Augmentation #cite(<murel-jacob-2025b>, form: "normal")],
  [Image Augmentation],
)) <data-augmentation>

@data-augmentation illustrates an example of data augmentation applied to images. The original image is transformed into multiple variations through techniques such as flipping, rotation, blurring, exposure adjustment, contrast adjustment, and conversion to grayscale. This process addresses dataset limitations by increasing diversity in the training samples, thereby improving the model’s generalization capability.

==== Batch Learning
According to @geeksforgeeks_batch_2025, batch learning, also called offline learning, is a type of learning where the model trains on the entire dataset at once. The researchers opted for batch learning in this study due to the static nature of the dataset, which consisted of a fixed collection of labeled images that did not require real-time updates. The advantages of batch learning in this study include enhanced stability, reproducibility, and accuracy.

#figure(
  image("./img/batch-learning.png"),
  caption: flex-caption(
    [Batch Learning vs Online Learning #cite(<gaidhane_batch_2023>, form: "normal")],
    [Batch Learning vs Online Learning],
  ),
) <batch-learning-img>

@batch-learning-img shows the difference between batch learning and online learning. According to Gaidhane (2023), the key difference between batch learning and online learning is that batch learning requires a fixed dataset. Batch learning is typically faster and requires less computational resources than online learning, but may not be as flexible in handling changing or large datasets. Online learning, on the other hand, can be more flexible and adaptable due to incremental learning, where the model trains on new data as it arrives. However, it may require more resources and is slower to process data.

==== Class Balancing
Class balancing refers to techniques used to address imbalances in the dataset where certain classes, such as specific disease categories, have significantly fewer samples than others like healthy cases, preventing the model from biasing toward the majority class and improving overall performance, as explained by Kharwal (2021), who defines it as balancing classes with unbalanced samples to avoid skewed learning in machine learning models.

In this research, the researchers implemented a weighted Cross Entropy Loss, a technique that adjusts the loss function to assign higher penalties to misclassifications of underrepresented classes in the imbalance dataset. It helps to improve model performance on minority classes.

==== Learning Rate Scheduling
As stated by @chugani_gentle_2025, learning rate schedulers are algorithms that automatically adjust the model’s learning rate during training. Instead of using the same learning rate from start to finish, these schedulers change it based on predefined rules or training performance.

#figure(
  image("./img/reduceLR-scheduler.png"),
  caption: flex-caption(
    [ReduceLROnPlateau Scheduler #cite(<chugani_gentle_2025>, form: "normal")],
    [ReduceLROnPlateau Scheduler],
  ),
)

In this research, the researchers applied an adaptive plateau reduction scheduler which is ReduceLROnPlateau. ReduceLROnPlateau monitors validation metrics and reduces the learning rate only when improvement stagnates. Unlike StepLR which reduces learning rate by a factor on n number of epochs, ReduceLROnPlateau automatically reduces the learning rate by the defined factor if the validation loss does not improve for n number of epochs. The main advantage of this is its simplicity and responsiveness to training dynamics.

==== Early Stopping
According to @murel_what_2023, early stopping is the most readily implemented regularization technique. Early stopping limits the number of iterations during model training.
#figure(
  image("./img/early-stopping.png"),
  caption: flex-caption([Early Stopping #cite(<murel_what_2023>, form: "normal")], [Early Stopping]),
) <early-stopping-img>
@early-stopping-img shows a model continuously passing through the training data. Early stopping makes it so that it stops once there is no more improvement in training and validation accuracy after a predefined number of epochs has passed. The goal is to train a model until it has reached the lowest possible training error preceding a plateau or increase in validation error. This technique helped the researchers to save time and GPU usage on colab, preventing the model from training more epochs even if the model is not improving anymore.

==== Evaluation Metrics
Model evaluation is the process of using different evaluation metrics to understand a machine learning model’s performance, as well as its strengths and weaknesses. Model evaluation is important to assess the efficacy of a model during initial research phases, and it also plays a role in model monitoring #cite(<domino_what_nodate>, form: "normal").
The researchers used multiple evaluation metrics to systematically monitor training dynamics and rigorously assess the predictive performance of the model across different experimental setups.

===== Accuracy
It is a fundamental metric for evaluating the performance of a classification model. It tells us the proportion of correct predictions made by the model out of all predictions #cite(<geeksforgeeks_evaluation_2025>, form: "normal"). In the context of this study, where the objective is to classify images into multiple fingernail feature categories, accuracy provides an intuitive and holistic measure of the model’s predictive effectiveness.

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

===== Precision / Positive Predictive Value (PPV)
Precision or Positive Predictive Value measures how many of the positive predictions made by the model are actually correct. It’s useful when the cost of false positives is high, such as in medical diagnoses where predicting a disease when it’s not present can have serious consequences. The formula of precision is defined as:

#figure(
  kind: "equation",
  [
    $"Precision/PPV" = "TP"/("TP" + "FP")$
  ],
  caption: flex-caption(
    [Formula for Precision/PPV #cite(<geeksforgeeks_evaluation_2025>, form: "normal")],
    [Formula for Precision/PPV],
  ),
)
where TP denotes True Positive and FP denotes False Positive. In multiclass classification, precision is computed per class and can be averaged (macro, micro, or weighted) to obtain an overall measure #cite(<sokolova_systematic_2009>, form: "normal").

===== Negative Predictive Values (NPV)
According to @pedigo_sensitivity_2025, Negative Predictive Value (NPV) reflects the reliability of a negative result. It measures the proportion of negative test results that are true negatives. The formula is defined as:
#figure(
  kind: "equation",
  [
    $"NPV" = "TN" / ("TN" + "FN")$
  ],
  caption: flex-caption([Formula for NPV #cite(<pedigo_sensitivity_2025>, form: "normal")], [Formula for NPV]),
)
where TN denoted True Negative and FN denoted False Negatives.

===== Recall / Sensitivity
According to @pedigo_sensitivity_2025, recall or sensitivity, also called true positive rate, measures the model’s ability to correctly identify true positives. More precisely, it is the proportion of true positives to actual positives. The formula for recall is defined as:

#figure(
  kind: "equation",
  [
    $"Recall / Sensitivity" = "TP" / ("TP" + "FN")$
  ],
  caption: flex-caption([Formula for Recall #cite(<pedigo_sensitivity_2025>, form: "normal")], [Formula for Recall]),
)

where TP denotes True Positive and FN denotes False Negatives.

===== Specificity
Similarly, specificity (true negative rate) measures the model's ability to identify true negatives. It is the proportion of true negatives to actual negatives. #cite(<pedigo_sensitivity_2025>, form: "normal").

#figure(
  kind: "equation",
  [
    $"Specificity" = "TN" / ("FP" + "TN")$
  ],
  caption: flex-caption(
    [Formula for Specificity #cite(<pedigo_sensitivity_2025>, form: "normal")],
    [Formula for Specificity],
  ),
)

===== F1-Score
According to @geeksforgeeks_evaluation_2025 the F1 Score is the harmonic mean of precision and recall. It is useful when we need a balance between precision and recall as it combines both into a single number. A high F1 score means the model performs well on both. The formula for F1-Score is defined as:

#figure(
  kind: "equation",
  [
    $"F1 Score" = 2 times ("Precision" times "Recall") / ("Precision" + "Recall")$
  ],
  caption: flex-caption(
    [Formula for F1-Score #cite(<geeksforgeeks_evaluation_2025>, form: "normal")],
    [Formula for F1-Score],
  ),
)

===== Confusion Matrix
@geeksforgeeks_understanding_2025 defines confusion matrix as a simple table used to measure how well a classification model is performing. It compares the predictions made by the model with the actual results and shows where the model was right or wrong. This helps in understanding where the model is making mistakes.
#figure(
  image("./img/confusion-matrix.jpg"),
  caption: flex-caption(
    [Confusion Matrix #cite(<geeksforgeeks_understanding_2025>, form: "normal")],
    [Confusion Matrix],
  ),
)

==== Modularization
==== Model Interpretability

=== Algorithm Analysis
In order to evaluate the performance of deep learning models for nail feature classification, the researchers considered a set of architectures that represent different stages of advancement in computer vision research. The selection of models was guided by two principles: the first is ensuring diversity in architectural design to capture a broad range of representational capabilities, and the second one is relying on established benchmarks such as ImageNet Top-1 and Top-5 accuracy, parameter counts, and computational complexity (GFLOPs) as reported in the official PyTorch model repository. These criteria provide a standardized basis for comparison and ensure that the chosen models span from classical convolutional networks to modern transformer-based approaches.

==== VGG-16
VGG-16, introduced by @simonyan_very_2015, is one of the earliest deep convolutional neural networks that achieved state-of-the-art performance on ImageNet. Its hallmark is the use of a simple and uniform architecture: stacks of 3 by 3 convolutional filters, followed by max-pooling layers, and fully connected layers at the end. Despite having a large parameter count of 138.4 million and GFLOPs of 15.47, VGG16 became widely adopted due to its straightforward design and effectiveness in transfer learning applications. In this study, VGG-16 serves as a classical baseline, allowing comparison between traditional CNNs and modern architectures.

#figure(
  image("./img/vgg16_architecture.jpg"),
  caption: flex-caption([Architecture of VGG-16 #cite(<hassan_vgg16_2018>, form: "normal")], [Architecture of VGG-16]),
) <vgg-architecture>

@vgg-architecture shows the architecture of the model VGG-16. According to @hassan_vgg16_2018, VGG-16 processes fixed-size 224×224 RGB images through a deep stack of convolutional layers with very small receptive fields (3×3, and occasionally 1×1 for channel-wise transformations), stride 1, and padding to preserve spatial resolution. Spatial pooling is applied via five max-pooling layers with 2×2 windows and stride 2, interspersed between convolutional blocks. This feature extraction stage is followed by three fully connected layers: two with 4096 channels and a final layer with 1000 channels for ImageNet classification, capped by a softmax output. All hidden layers use ReLU activations, and Local Response Normalization was largely excluded, as it increased memory and computation without improving performance.

==== ResNet-50
ResNet-50, developed by @he_deep_2015, introduced the concept of residual connections, which alleviated the vanishing gradient problem and enabled the training of very deep networks. With only 25.6 million parameters and 4.09 GFLOPs, ResNet50 is significantly more efficient than VGG-16 while achieving higher accuracy on ImageNet benchmarks. It has since become one of the most widely used backbones for computer vision tasks, particularly in medical imaging. Its inclusion in this research provides a strong reference point as an “industrial standard” CNN model.

#figure(
  image("./img/resnet50_architecture.jpg"),
  caption: flex-caption(
    [Architecture of ResNet-50 #cite(<mukherjee_annotated_2022>, form: "normal")],
    [Architecture of ResNet-50],
  ),
) <resnet-architecture>

@resnet-architecture shows the architecture of ResNet-50. According to @he_deep_2015 ResNet-50 is a 50-layer deep convolutional neural network that introduced residual learning to overcome the vanishing gradient problem, enabling the training of very deep models with high accuracy. Its architecture consists of an initial convolutional layer followed by four stages of residual blocks, each built using a bottleneck design: a 1×1 convolution for dimensionality reduction, a 3×3 convolution for spatial feature extraction, and another 1×1 convolution to restore dimensions. These blocks are connected by shortcut, or identity, connections that allow gradients to bypass layers during backpropagation, ensuring stable optimization even in very deep networks.

==== RegNetY-16GF
RegNet, introduced by @radosavovic_designing_2020, is based on the idea of designing network design spaces rather than fixed architectures. The RegNetY family incorporates Squeeze-and-Excitation (SE) blocks for channel-wise feature recalibration. The RegNetY-16GF variant offers a balance between large capacity (83.6 million parameters and 15.91 GFLOPs) and practical scalability. It has been shown to outperform EfficientNets under standardized training regimes, making it a compelling candidate for tasks requiring both accuracy and generalization. Its inclusion provides a modern convolutional model optimized for performance-efficiency trade-offs. Initially, the researchers included this model. However, upon learning that it is computationally more expensive to train despite having about the same parameters and GFLOPs as VGG16, the researchers have dropped this model.

==== EfficientNetV2-S
EfficientNetV2, proposed by @tan_efficientnetv2_2021, is the successor to EfficientNet and was designed to achieve faster training and improved parameter efficiency. The “S” (small) variant balances accuracy and computational requirements, using fused MBConv layers and progressive learning strategies such as variable image resizing and adaptive regularization scheduling. With 21.5 million parameters and 8.37 GFLOPS, EfficientNetV2S achieves high accuracy with relatively fewer resources, making it suitable for healthcare deployment where efficiency and scalability are critical. Its role in this study is to represent modern efficiency-oriented CNNs.

==== SwinV2-T
Swin Transformer V2 #cite(<liu_swin_2022>, form: "normal") builds on the original Swin Transformer by introducing residual-post-norm and scaled cosine attention, improving training stability for deep models. It also addresses the “resolution gap” problem, enabling pretrained models to transfer more effectively to higher resolutions—a feature relevant in medical imaging where fine details matter. The Tiny variant (SwinV2-T) has approximately 28.4 million parameters and 5.94 GFLOPs, making it a lightweight alternative compared to Base or Large variants. Despite its efficiency, it still benefits from hierarchical self-attention and the ability to model long-range dependencies, providing a transformer-based counterpart to convolutional architectures in nail feature classification.

==== ConvNeXt-Tiny
Upon observing that RegNetY-16GF is computationally more demanding despite having a comparable number of parameters and GFLOPs to VGG16, the researchers opted to replace it with ConvNeXt-Tiny. This decision was motivated by the need to conduct multiple experiments efficiently, as ConvNeXt-Tiny offers a favorable balance between performance and computational cost. Introduced by Liu et al. (2022), ConvNeXt demonstrated competitive or superior performance compared to Vision Transformers across various benchmarks, while retaining the advantages of convolutional inductive biases that make training more stable and efficient on smaller datasets. The Tiny variant, in particular, was chosen because it offers a favorable trade-off between accuracy and computational cost, with approximately 28 million parameters, making it more practical for experimentation in a resource-constrained environment such as Google Colab.

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
To ensure consistency across all the experiments, we used the same training covering the optimization algorithm, learning rate scheduling and loss function. For the optimizer, we used the AdamW optimizer #cite(<loshchilov_decoupled_2019>, form: "normal"), which decouples weight decay from the gradient update rule, providing improved generalization compared to standard Adam. The learning rate was adjusted using the ReduceLROnPlateau scheduler, which monitors the validation loss and reduces the learning rate by a factor of γ (gamma) once performance plateaus. This adaptive adjustment prevents overfitting and allows the model to converge more efficiently, which is particularly important in medical imaging tasks where datasets are relatively small and prone to variance. The effectiveness of ReduceLROnPlateau in stabilizing transfer learning for medical image analysis has been demonstrated in prior studies #cite(<rajpurkar_chexnet_2017>, form: "normal"). To address class imbalance in the nail disease dataset, we employed a weighted Cross-Entropy Loss, where class weights were computed inversely proportional to class frequencies. This ensures that underrepresented classes contribute more significantly to the loss, preventing the model from being biased toward majority classes. Weighted Cross-Entropy Loss is widely adopted in medical image classification where imbalanced datasets are common #cite(<buda_systematic_2018>, form: "normal").

==== Training Strategies
===== Training from scratch
In this setup, the model is initialized with random weights and trained end-to-end on the nail disease dataset. Unlike transfer learning, no pre-trained ImageNet features are used. This serves as a control experiment to assess the value of transfer learning by showing how the model performs when forced to learn all representations from the target dataset alone.

===== Baseline
The baseline is defined as freezing all pretrained weights of the backbone and training only the classification head. This evaluates how well ImageNet-pretrained features transfer to the nail disease dataset without any fine-tuning, establishing a point of comparison for more adaptive strategies.

===== Full Fine-Tuning
In this approach, all layers of the pretrained model are unfrozen and updated during training. This allows the entire network to adapt more thoroughly to the nail disease dataset, often leading to higher accuracy. Multiple studies in medical image classification have demonstrated that full fine-tuning outperforms head-only or partial fine-tuning in many cases (e.g., @peng_rethinking_2023 and @davila_comparison_2024), albeit with increased risk of overfitting when training data are limited.

===== Gradual Unfreezing
Following the approach by @howard_universal_2018, gradual unfreezing begins by training only the classification head, then progressively unfreezing earlier layers of the network over training epochs. The researchers adopted this fine-tuning strategy to prevent catastrophic forgetting and allow the network to adapt progressively to the fingernail dataset. Unlike other ULMFiT (Universal Language Model Fine-Tuning) components such as discriminative learning rates or slanted triangular schedules, gradual unfreezing was selected for its simplicity and stability in vision-based transfer learning tasks. This approach enables efficient optimization while maintaining pre-trained feature representations.

==== Bayesian Inference
In contrast to deterministic fine-tuning, Bayesian inference provides a probabilistic framework, treating parameters as random variables and updating priors with data to yield posteriors via Bayes' theorem: $p(theta | y) prop p(y | theta) p(theta)$. As detailed in @gelman_bayesian_2013, computation involves methods like MCMC, variational inference, and Hamiltonian Monte Carlo, enabling uncertainty quantification essential for medical applications to avoid overconfidence. In our nail disease pipeline, it calculates posterior probabilities of systemic conditions from detected features, incorporating population priors and conditionals. Advantages include robustness to limited data via informative priors, though it requires more computation and careful prior selection, as discussed in hierarchical modeling and model checking.

=== Data Collection Methods
The performance and reliability of any machine learning–based diagnostic system depend on the quality and representativeness of the data used for model development. In this study, the researchers curated a labeled dataset of fingernail images to support multiclass disease classification. Additionally, to enable probabilistic inference of systemic diseases from nail features, the researchers organized and processed a complementary statistical dataset that captures the relevant associations between nail characteristics and disease outcomes.

==== Image Dataset
The dataset utilized for this study is sourced from a publicly available Nail Disease Detection collection hosted on Roboflow, and is released under the Creative Commons Attribution 4.0 (CC BY 4.0) license. The dataset comprises a total of 7,264 images, annotated using the TensorFlow TFRecord (Raccoon) format, covering 11 classes of nail diseases. However, the researchers have dropped Lindsay's Nail class due to few number of images.

The researchers decided to revise the name of the class from “acral lentiginous melanoma” to “melanonychia” for medical specificity. As determined from the experts' interview done by the researchers to Dr. Cristine Florentino, acral lentiginous melanoma is a diagnosis in itself and not a finding on a physical exam. Conversely, melanonychia (a hyperpigmentation of the nail plate) is a measurable nail feature, thus making it the more appropriate name for the dataset. Because not all images may have been confirmed to depict acral lentiginous melanoma but they all exhibit features of melanonychia, such a revision allows the dataset to depict clinical specificity and not portray a diagnosis as a finding on the nails.

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
    ),
    #v(-2em)
  ],
  caption: [Sample distribution per class across dataset splits.],
)<class-distribution>


The final dataset used in this study consists of 7,258 labeled nail images, divided into three subsets: training (6,360 images, 88%), validation (591 images, 8%), and testing (307 images, 4%) as illustrated in @class-distribution.

Each subset contains images from ten nail disease classes, with class distributions reflecting a natural imbalance. The training set is used for model learning, the validation set for hyperparameter tuning and early stopping, and the test set for final evaluation.

The class with the highest representation across all sets is Terry's Nail, while Muehrcke’s Lines is the most underrepresented.

Weighted loss was used during training to compensate for class imbalance and improve model fairness across underrepresented classes.\

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

Although the dataset was initially preprocessed and augmented through Roboflow's pipeline, additional preprocessing steps were performed to ensure compatibility with the PyTorch deep learning framework. Specifically, all images were resized to $224 × 224$ pixels, which is the standard input dimension for most pre-trained Convolutional Neural Network (CNN) architectures in PyTorch.

Each image was then converted into a tensor format to facilitate numerical computation during training and inference. Furthermore, normalization was applied using the mean and standard deviation values commonly used by PyTorch’s pre-trained models on the ImageNet dataset. This normalization ensures consistency in input distribution, allowing for more stable and efficient model convergence.

These preprocessing steps were essential for adapting the dataset to the specific requirements of the chosen model architectures and the deep learning environment used in this study.

==== Statistical Dataset
To complement the image-based dataset and enable Bayesian inference for linking detected nail features to potential underlying diseases, a separate statistical dataset was manually curated. This dataset was compiled from peer-reviewed literature, scientific journals, public health databases, and reliable online statistical sources, with a focus on extracting probabilities and demographic data relevant to the Philippine population where available. The curation process involved systematic searches on platforms such as PubMed Central (PMC), Lippincott Williams & Wilkins (LWW) journals, Statista, Wikipedia (for demographic overviews), and specialized medical sites like Capitol Medical Center and HERDIN. Each entry was cross-verified for accuracy, and only data from credible, cited sources were included to ensure reliability for probabilistic modeling.

The statistical dataset is structured in an CSV file format, containing rows for each nail feature-disease association. Key columns include: `Nail Feature`, `Associated Disease/Condition`, `P(Nail|Disease)` (conditional probability of the nail feature given the disease), `P(Disease)` (prior probability of the disease), `P(Disease) Population` (population-specific prevalence), `P(Disease) Sex_Female` and `P(Disease) Sex_Male` (sex-specific probabilities), `Age (Mean)`, `Age_Low`, `Age_High` (age demographics), and `Source` Citation for `P(Nail|Disease)` and `P(Disease)` (hyperlinks to original sources for transparency and reproducibility).

This dataset covers 31 associations across 10 nail features (aligning with the image dataset classes), linking them to conditions such as COVID-19, chemotherapy side effects, gastrointestinal diseases, renal failure, anemia, heart disease, and others. Probabilities were derived from epidemiological studies, clinical reports, and global cancer registries (e.g., GLOBOCAN), adapted to Philippine contexts when data permitted. No primary data collection was conducted; all values represent literature-based estimates to support posterior probability calculations in Bayesian frameworks.

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
  caption: [Sample distribution per class across dataset splits],
)

To illustrate the probabilistic data available for Bayesian inference, a sample table of selected entries is provided below. This excerpt focuses on core columns related to probabilities and demographics, showcasing a subset of associations across various nail features. Values are presented as curated from literature, with probabilities expressed as decimals (e.g., 0.186 representing 18.6%).

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
)

This sample showcases how the dataset can be used to compute likelihoods, such as the conditional probability of observing a specific nail feature given a disease, combined with disease priors for posterior estimations.

=== Data Model Generation
This section presents the systematic framework employed in the development of the deep learning model for nail disease classification and probabilistic inference of systemic diseases. The process adheres to standard machine learning practices and scientific methodologies, particularly aligning with the phases found in the Cross-Industry Standard Process for Data Mining (CRISP-DM) and other established machine learning pipelines. Each step is carefully designed to ensure reproducibility, scalability, and clinical relevance. The researchers also applied principles of modular software design and Object-Oriented Programming (OOP), in conjunction with the Don’t Repeat Yourself (DRY) principle as articulated by @hunt_pragmatic_1999 in The Pragmatic Programmer, to facilitate multiple experimental setups while minimizing redundant code across models and configurations.

==== Data Loading and Preprocessing
#figure(
  image("./img/system-archi-model-section1.png"),
  caption: [Data Loading and Preprocessing Workflow],
) <data-loading-and-prep>

As shown in @data-loading-and-prep, the process begins with the researcher cloning the project repository into the Google Colab environment, which provides GPU-accelerated computational resources for deep learning tasks. The dataset is accessed via a version-controlled GitHub repository to ensure reproducibility and consistent data handling across experiments. The Data Loader component retrieves the images, categorizing them into training, validation, and testing subsets. This partitioning aligns with standard machine learning practice, preventing data leakage and enabling unbiased model evaluation.

The Data Loader performs several preprocessing operations to ensure that the dataset is properly formatted and standardized. Each image is resized to 224×224 pixels to match the standard input size used when training common vision models like VGG, ResNet, EfficientNet, ConvNeXt-Tiny, and SwinV2-T. While these models can handle images with different resolutions, the 224×224 size is commonly used because it follows the ImageNet training setup and works best with pretrained model weights. The images are then converted into tensor format for compatibility with PyTorch-based deep learning frameworks. Normalization is applied using ImageNet statistical parameters to stabilize the training process and accelerate convergence by aligning the data distribution with pretrained feature spaces. To further enhance the generalization ability of the model, data augmentation techniques such as random flipping, rotation, and brightness adjustments are applied. These augmentations simulate real-world variations in lighting and orientation, allowing the model to learn more invariant representations of nail features. The final preprocessed dataset is then returned to the Google Colab environment as ready-to-train data, forming the foundation for all subsequent model learning processes.
==== Model Training
#figure(
  image("./img/system-archi-model-section2.png"),
  caption: [Model Training Workflow],
)

The second phase of the data model generation focuses on training the deep learning model to recognize relevant nail biomarkers. This process involves the interaction between the training engine, model, loss function, optimizer, and learning rate scheduler. The training begins with initializing a pretrained CNN architecture, such as VGG-16, ResNet-50, EfficientNetV2-S, SwinV2-T, or ConvNeXt-Tiny. Transfer learning is employed to leverage the high-level visual representations learned from large-scale datasets such as ImageNet, thus improving model convergence and reducing the amount of required training data. The use of transfer learning is supported by empirical findings demonstrating that pretrained weights significantly enhance model performance in specialized domains like medical imaging.

During training, the system employs a Weighted Cross-Entropy loss function to mitigate class imbalance issues inherent in medical datasets, ensuring that underrepresented classes contribute proportionally to gradient updates. The AdamW optimizer is used with a learning rate of 1×10⁻⁴, combining adaptive moment estimation with decoupled weight decay to achieve efficient optimization and better generalization. The ReduceLROnPlateau scheduler dynamically adjusts the learning rate when validation performance stagnates, preventing premature convergence and maintaining training stability. Each training epoch consists of forward propagation, where the model produces predictions from input data; loss computation, where discrepancies between predictions and true labels are quantified; and backpropagation, where gradients are propagated through the network to update weights. This iterative process continues until convergence or until early stopping criteria are met, ensuring the trained model attains optimal balance between learning capacity and generalization performance.

==== Model Validation and Evaluation
#figure(
  image("./img/system-archi-model-section3.png"),
  caption: [Model Validation and Performance Monitoring Workflow],
)
The third phase manages a step-by-step process that checks and improves how well the model works after each training epoch. After every epoch, the validation engine tests the model on new data without updating the model’s weights. This makes sure the results are fair and do not affect the training. The Metrics Calculator then quickly measures the validation loss and accuracy to show how well the model is doing. These results are sent back as feedback.

Based on the feedback, there are two possible actions. If the validation results are the best so far, the system saves the current model as a checkpoint. This keeps the best version of the model. If the results stop getting better, the early stopping system checks if it should stop training. Depending on this check, the system either lowers the learning rate or stops training to save time and avoid overfitting. The model was then evaluated using the metrics stated in applied concepts which are the accuracy, confusion matrix, precision, recall, F1 score, and training and validation losses and accuracies.

This process makes sure that only the best model is saved and used at the end of training. It is a strong way to keep checking and making decisions automatically, so the model is as accurate and general as possible before it is used.

==== Systemic Disease Inference
Following the model evaluation phase, where the trained CNN and ViT models were assessed for their accuracy in detecting nail features such as pitting, clubbing, or healthy nails on the test dataset, the next stage involved utilizing these detection outputs for probabilistic inference of underlying systemic diseases. This inference step bridges the gap between visible nail abnormalities and potential conditions, utilizing Bayesian principles to estimate disease probabilities conditioned on the observed nail features. To enhance the reliability of predictions, the system incorporates a calibration mechanism based on the model’s confusion matrix, adjusting raw CNN confidence scores to better estimate true feature probabilities.
#figure(
  image("./img/systemic-disease-archi.png"),
  caption: [Disease Probability Computation Workflow],
) <systemic-disease-archi>
As shown in @systemic-disease-archi, the final phase performs probabilistic reasoning to derive disease likelihoods from the model’s predictions. When the AI model produces raw confidence scores for detected nail features, these values undergo calibration through the confusion matrix to ensure statistical reliability. Calibration aligns the model’s output probabilities with empirical distributions observed during validation, thereby correcting potential overconfidence. The system then retrieves conditional probabilities $P("Nail" | "Disease")$  and prior probabilities $P("Disease")$ from the statistical dataset stored in CSV format. Using Bayes’ theorem, the Bayesian inference engine computes posterior probabilities $P("Disease" | "Nail")$, integrating both the model’s evidence and historical statistical relationships.

To improve diagnostic precision, the system incorporates demographic adjustment by modifying disease priors according to the user’s age and sex. This adjustment accounts for population-level prevalence variations, aligning system outputs with real-world epidemiological data. The final probabilities are normalized and ranked, generating a list of potential diseases along with their respective likelihoods. For instance, the system may output results such as Psoriasis (91.24%) and Alopecia Areata (7.29%). This process merges data-driven feature recognition with probabilistic reasoning, offering interpretable and clinically meaningful insights. The hybridization of deep learning and Bayesian inference enhances the transparency and reliability of AI-based medical diagnosis, addressing the interpretability challenges commonly associated with black-box neural networks population-level prevalence variations, aligning system outputs with real-world epidemiological data. The final probabilities are normalized and ranked, generating a list of potential diseases along with their respective likelihoods. For instance, the system may output results such as Psoriasis (91.24%) and Alopecia Areata (7.29%). This process merges data-driven feature recognition with probabilistic reasoning, offering interpretable and clinically meaningful insights. The hybridization of deep learning and Bayesian inference enhances the transparency and reliability of AI-based medical diagnosis, addressing the interpretability challenges commonly associated with black-box neural networks.

The inference pipeline was designed to be modular and dynamic, allowing integration with varying CNN confidence scores from different nail scans. It incorporates prior knowledge from a curated dataset of nail feature-disease associations, adjusting for user demographics such as age and sex to refine predictions, and applies post-hoc calibration to account for systematic misclassifications. This section details the data preparation, confusion matrix calibration, Bayesian model setup, inference computation, demographic integration, and output generation, ensuring the system remains generalizable for testing diverse nail images without hardcoding specific features like pitting.

===== Data Preparation for Inference
The foundation of the disease inference relies on a probabilistic dataset compiled in a CSV file (e.g.,”StatisticalDataset.csv”), which maps nail features to associated diseases or conditions. This dataset includes key columns such as `Nail  Feature` (e.g., “Pitting”, “Clubbing”), `Associated Disease/Condition` (e.g., “Psoriasis”, “Lung Cancer”), conditional probabilities `P(Nail|Disease)` scaled from 0-1 (representing the likelihood of observing the nail feature given the disease), prior probabilities `P(Disease)` also scaled from 0-1 (indicating base prevalence in the population), demographic priors like `P(Disease|Sex_Female)` and `P(Disease|Sex_Male)`, and age-related parameters (mean, low, and high ranges).

The CSV was loaded into a Pandas DataFrame within a Python script, with missing values handled via Pandas’ `fillna` method to ensure robustness. A dictionary structure (`feature_to_disease`) was constructed using `defaultdict` from the `collections` module, grouping diseases by nail feature for efficient lookup. Each entry in this dictionary encapsulated the disease name, $P("Nail" | "Disease")$, $P("Disease")$, sex-specific priors, and age bounds. For the “Healthy Nail” feature linked to “No systemic disease”, a default prior P(Disease) of 1.0 was assigned to represent the baseline absence of pathology, while invalid or zero-probability entries were skipped to avoid computational errors.

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
To address potential biases and misclassifications in the CNN’s raw confidence scores (e.g., overconfidence in certain features or systematic confusion between similar classes like pitting and koilonychia), a calibration step was integrated using the model’s confusion matrix derived from the test set evaluation. The confusion matrix, a $10 times 10$ array (matching the 10 nail features classes), captures the counts of true labels versus predicted labels, normalized row-wise to yield conditional probabilities $P("Predicted" | "True")$.

In this script, the confusion matrix is obtained directly from the model’s evaluation results, with rows representing true labels and columns predicted labels, ordered consistently with the feature labels (e.g., Melanonychia first, Terry’s Nails last). Normalization produces the confusion probability matrix `conf`. The raw CNN confidences are vectorized into a predicted probability vector `q` (in the same label order), which is then adjusted to estimate the true feature probabilities `p` using the pseudoinverse of the confusion matrix: `p = pinv(conf) @ q`. Negative values in `p` are clipped to zero, and the vector is renormalized to sum to 1, ensuring valid probabilities.

This calibration acts as a debiasing transform, compensating for the model’s error patterns, for instance, if the model frequently confuses clubbing with healthy nails, the adjusted probabilities redistribute confidence more accurately. The adjusted_confidence dictionary replaces the raw confidences in subsequent Bayesian computations, improving downstream disease inference fidelity. For dynamic use, the confusion matrix can be updated from ongoing evaluations, making the system adaptable to model retraining.

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
The inference employs a naive Bayesian framework, assuming conditional independence among nail features for simplicity, while weighting contributions by the calibrated confidence scores (normalized to 0-1 probabilities). These adjusted scores represent a more reliable estimate of the true presence of each nail feature (e.g., Pitting: potentially adjusted from 0.9962 based on matrix corrections). The setup computes unnormalized posteriors for each disease associated with detected features, then normalizes across all diseases to yield a probability distribution.

For each nail feature with positive adjusted confidence (`p_f_image > 0`), the script iterates over linked diseases, calculating the effective prior by incorporating demographics. Sex-specific adjustments use $P("Disease" | "Sex")$ if available, multiplying by the base $P("Disease")$ only if sex priors sum approximately to 1 (indicating they are conditional probabilities); otherwise, they are treated as absolute priors. Age filtering applies a uniform density within specified ranges (e.g., `p_age_d = 1 / (high - low) if within bounds, else 0`), effectively zeroing out diseases mismatched to the user’s age.

The unnormalized posterior for a disease `d` given feature `f` is `p_fd * effective_prior`, summed across diseases for normalization into `p_d_f`. This is then weighted by `p_f_image` and aggregated across all features, allowing multiple features to contribute evidence proportionally. Final normalization ensures the posteriors sum to 1, providing a ranked list of potential diseases.

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
  caption: [Bayesian Posterior Computation with Calibrated Inputs],
)

===== Demographic Integration and User Prompting
The researchers implemented a functionality that prompts the user for sex (male/female) and age via input functions, assuming adult users unless specified. These inputs are used to modulate priors: for instance, if a disease like Congenital Heart Disease has an age range of 0-0 (implying neonatal onset), an adult user’s age would set `p_age_d` to 0, excluding it. This step enhances accuracy by avoiding implausible matches, such as elderly-specific conditions for young users. If demographics are unavailable or irrelevant (e.g., no sex priors in the data), the base $P("Disease")$ is used unaltered.

The prompting is kept minimal to maintain usability, occurring after CNN evaluation but before inference. Edge cases, like non-binary sex or invalid ages, are handled by defaulting to unadjusted priors, though future iterations could incorporate more inclusive demographics.

===== Inference Execution and Dynamic Handling
The script executes the inference by processing the calibrated confidence dictionary, which is dynamically populated (e.g., from model outputs) rather than hardcoded. For testing different nails, users can replace the raw confidence values, with calibration automatically applied; for example, a high raw pitting score might be tempered if the matrix shows frequent false positives, while clubbing could be boosted if underrepresented. The system avoids confusing high-confidence features like pitting with low ones like healthy nails by relying on the adjusted probabilities (e.g., raw 0.0028 for healthy treated accordingly post-calibration).

The computation avoids direct $P("Nail")$ derivation unless necessary, focusing on proportional posteriors to bypass marginalization over all diseases. This efficiency is crucial for real-time applications. Posterior are stored in a `defaultdict`, sorted descendingly, and output in a human-readable format, listing diseases with percentages (e.g, Psoriasis: 91.24%).

===== Output Generation and Interpretation
The final output mirrors a clinical report: “Potential Systemic Diseases (Probabilities)” followed by a sorted list (e.g., Psoriasis: 91.24%, Alopecia areata: 7.29%), This encourages users to view results as hypothesis, not diagnoses, prompting medical follow-up. For healthy nails with high confidence, “No systemic disease” dominates, providing reassurance.

In case of multiple high-confidence features, the aggregation ensures balance evidence; for low-confidence scans, posterior dilute across possibilities. The calibration step further refines this by correcting for model imperfections, leading to more robust outputs. The systems’s generality supports iterative testing: upload a new nail image, evaluate via CNN, calibrate confidences, feed to inference, and interpret anew.

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

This inference module completes the pipeline, transforming raw nail images into actionable health insights through calibrated probabilistic reasoning, all implemented in Python for accessibility and extensibility.

=== System Development Methodology
The researchers applied the simplest Agile framework called Kanban methodology in the study. According to @the_pm_professional_kanban_2024, Kanban, originating from lean manufacturing principles, provides teams with a visual representation of their workflow using a Kanban board. Tasks are represented as cards moving through different stages, allowing teams to track progress at a glance. By limiting WIP, Kanban ensures that teams focus on completing tasks before taking on new ones, thus preventing bottlenecks and improving efficiency.
#figure(
  image("./img/Abstract_Kanban_Board.jpg"),
  caption: flex-caption(
    [Representation of a Kanban Board #cite(<falco_english_2023>, form: "normal")],
    [Representation of a Kanban Board],
  ),
)
A software development company that started using Kanban saw better teamwork, fewer delays, and higher productivity by making their workflow visible and limiting how much work they did at the same time #cite(<fastercapital_kanban_2025>, form: "normal"). In another example, a software services company used Kanban to get more done while still being able to respond quickly to changing client needs #cite(<kanban_university_visotech_2024>, form: "normal"). The Kanban method is helpful for keeping track of how work moves through a project. It’s a well-tested way to manage projects that helps teams make their workflows smoother, get more done, and give better results to clients. By using Kanban’s core ideas and practices, the researchers can respond easily to changing needs while also working better together and coming up with new ideas.

=== Software Tools Used
Software tools are computer programs, apps, libraries, or platforms used in the development and creation of systems and models, organized into five primary categories: development environments and languages; libraries, frameworks, and databases; platforms and version control; AI-assisted development; and documentation and communication tools.

==== Development Environments and Languages
===== Python
A popular programming language that is easy to read and use. It is often used for machine learning, web development, and data analysis. In this study, Python was the main language for building the AI models and the web application, using libraries like PyTorch and Flask.

===== Visual Studio Code
It is popular as an editor for developing web applications and AI models due to its flexibility, ability to run multiple programming languages and programs, as well as popularity among communities. It also has integrated tools for HTML, CSS, and JavaScript built-in tools. Additionally, developers may integrate extensions to get more features. There also comes an integrated terminal for the editor where developers may run commands and use version control without closing the program. It accelerates work as well as simplifies it. The researchers utilized VS Code for the development of the models and the website.

===== Google Colaboratory
It is an online tool from Google that lets users write and run Python code directly in their browser. It is popular in data science and machine learning because it is easy to use and provides powerful computing resources, including free access to GPUs and TPUs. The researchers used it to train and test their machine learning algorithms. It was chosen because it is free and easy to share with other researchers.

==== Libraries, Frameworks, and Databases
===== Pytorch
It is an open-source deep learning framework used in this study as the main environment for building, training, and testing AI models. It supports tensor computation with GPU acceleration, provides automatic differentiation for backpropagation, and offers modular neural network components. These features allowed the researchers to implement the model architecture and run experiments during training and evaluation more efficiently.

===== Matplotlib
It is a Python library used for data visualization. It helps create plots, charts, and graphs. In this study, the researchers used Matplotlib for Exploratory Data Analysis (EDA) to find patterns, trends, and distributions in the dataset. It was also used for overall data visualization, giving clear graphs that supported model evaluation and result interpretation.

===== Flask
The researchers used Flask, a simple and flexible web framework for Python, to build web applications and APIs. Flask makes it easier to create web projects by giving a clear structure for setting up servers, handling requests, and managing routes with less code.

===== Bootstrap
It is a front-end framework used by the researchers to build the website’s layout and design. It comes with ready-made CSS and JavaScript parts that made it easier to create responsive and mobile-first user interfaces. The researchers used Bootstrap’s grid system, utility classes, and reusable components to keep the website consistent, scalable, and efficient in its front-end development.

===== SQLite
It is a lightweight, serverless relational database system built directly into the application. In this study, the researchers used SQLite to store and retrieve structured data, such as user accounts, nail diagnosis results, and related records. Since SQLite is self-contained and requires very little setup, it was a good choice for managing local data efficiently while still being reliable and supporting ACID transactions.

==== Platforms and Version Control
===== Git
It is a distributed version control system used by the researchers to manage source code and project files. It was the main tool for version control during both model development and web application work. Git made it easier to track changes, create branches, and combine updates. It was also used to keep version history of Typst files, helping the researchers work together on revisions and protect the accuracy of the final manuscript.

===== GitHub
It is an online service used to store and share project source code. The researchers used it to manage and update their work, making it the main place for collaboration. Researchers pushed and pulled commits, kept track of version history, and worked on different branches to do tasks at the same time. GitHub also helped with issue tracking and repository management, which kept the workflow organized during the study.

===== Hugging Face
It is a platform that offers a hub for storing and sharing machine learning models. In this study, Hugging Face was used to host the trained models. This made it easier to keep track of different versions, repeat experiments, and deploy the models. It also allowed the models to be accessed directly through code during testing and experimentation.

==== AI-Assisted Development
===== AI Coding Assistants
The researchers used AI assistants that understand programming code, mainly GitHub Copilot which works inside Visual Studio Code. These tools helped speed up basic coding tasks. The main purpose of this AI was to automatically write code for repetitive tasks. This included creating standard code for Flask web routes, setting up the basic structure for PyTorch model classes, and writing functions to prepare data. Because the AI handled these simple tasks, the researchers could spend more time on more important work, like designing the main structure of the application and improving the logic of the neural network.

===== Conversational Language Models
The researchers used several conversational models, such as OpenAI's ChatGPT and Google's Gemini. They used these as interactive tools to help solve complex technical problems. These AI platforms helped them understand complicated error messages, rewrite Python code to make it more efficient and easier to read, and come up with ideas for improving the model's training process. In addition, the researchers used these models to help with writing. The AIs helped draft technical documents, generate clear descriptions for functions, and improve the final research paper. They did this by making sure all technical terms were used consistently and by making complex ideas easier to understand.

==== Documentation and Communication Tools
===== Zotero
It is a reference management tool used by the researchers to collect, store, and sync research sources. It helped organize citations, manage references on different devices, and create properly formatted bibliographies that supported the study’s documentation needs.

===== Google Docs
It is a cloud-based writing tool used by the researchers to draft and edit the manuscript. It supported real-time collaboration, tracked changes, and kept all files in one place, making sure edits and feedback were updated smoothly during the study.

===== Typst
It is a modern typesetting tool used by the researchers to create the final print-ready version of the manuscript. It helped make the document easier to read, kept the formatting consistent, and improved the overall look of the published work, giving the research a clear and professional output.

===== Discord
It is a communication tool used by the researchers for online meetings and discussions, especially when meeting in person was not possible. It offered real-time voice, video, and text channels that helped the group coordinate tasks, assign responsibilities, and track progress during the study.

=== Corpus Structure
=== Software Testing

#pagebreak()
#metadata("Chapter 3 end") <ch3-e>

#metadata("Chapter 4 start")<ch4-s>
#chp[Chapter IV]
#h2(outlined: false, bookmarked: true)[Results and Discussion]

=== System Architecture
#figure(
  image("./img/system-archi-web.png"),
  caption: [System Architecture Design],
) <system-architecture>
The system architecture as shown in @system-architecture operationalizes the trained model by integrating it into a fully functional backend environment. This manages real-time inference requests, database operations, and probabilistic computations. The workflow begins when a user uploads a nail image via the web-based interface. The API Gateway receives the image through an HTTP POST request, validating the data and forwarding it to the backend’s business logic layer. The uploaded image is temporarily stored in the local file system under a designated directory, while its file path and metadata are recorded in an SQLite database for traceability and reproducibility.

The Machine Learning Inference Service retrieves the image and performs classification using the trained deep learning model. The resulting prediction includes both the class label and its associated confidence score. The business logic layer then logs the output and queries the database for prior probabilities and likelihood values associated with the detected features. These are used by the Bayesian inference module to compute disease probabilities. The integration of database querying with inference ensures data consistency and enables the system to generate contextual, data-informed predictions. The results are transmitted back through the API Gateway to the front-end interface, where the user can view the diagnostic outcomes in an interpretable format.


=== Research Objective 1

=== Research Objective 2

=== Research Objective 3

=== Research Objective 4

=== Research Objective 5


#pagebreak()
#metadata("Chapter 4 end") <ch4-e>

#metadata("Chapter 5 start") <ch5-s>
#chp[Chapter V]
#h2(outlined: false, bookmarked: false)[Summary, Conclusions, Recommendations]

=== Summary

=== Conclusions

=== Recommendations

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

#h3(hidden: true)[RC Defense Transcription -- 07/29/2025]
#[
  #set par(spacing: 1em, leading: 1em)
  #include "./rc-defense-transcription.typ"
]

#h3(hidden: true)[Ma'am Villarica Consultation -- 08/19/2025]
#[
  #set par(spacing: 1em, leading: 1em)
  #include "./mam-mia-consultation.typ"
]

#h3(hidden: true)[Sir Bernardino Consultation -- 09/05/2025]
#[
  #set par(spacing: 1em, leading: 1em)
  #include "./sir-mark-consultation.typ"
]

#h3(hidden: true)[Sir Bernardino Consultation –- 10/07/2025]
#[
#set par(spacing: 1em, leading: 1em)
#include "./sir-mark-consultation2.typ"
]

#h3(hidden: true)[Ma’am Villarica Consultation –- 10/08/2025]
#[
  #set par(spacing: 1em, leading: 1em)
  #include "mam-mia-consultation2.typ"
]

#h3(hidden: true)[Sir Estalilla Consultation -- 10/13/2025]
#[
  #set par(spacing: 1em, leading: 1em)
  #include "./sir-estalilla-consultation.typ"
]

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

#h3(hidden: true)[Communication Letter]

#image("img/communication-letter-01.jpg", width: 100%, height: 96%)
#pagebreak()

#image("img/communication-letter-02.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/communication-letter-03.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/Request Letter_page-0001.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/Request Letter_page-0002.jpg", width: 100%, height: 100%)
#pagebreak()


#image("img/FOI Request Form_page-0001.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/FOI Request Form_page-0002.jpg", width: 100%, height: 100%)
#pagebreak()

#h3(hidden: true)[Rating Sheet]

#image("img/01_Title_Proposal_Rating_Sheet_page-0001.jpg", width: 100%, height: 96%)
#pagebreak()

#image("img/01_Title_Proposal_Rating_Sheet_page-0002.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/01_Title_Proposal_Rating_Sheet_page-0003.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/01_Title_Proposal_Rating_Sheet_page-0004.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/01_Title_Proposal_Rating_Sheet_page-0005.jpg", width: 100%, height: 100%)
#pagebreak()

#image("img/01_Title_Proposal_Rating_Sheet_page-0006.jpg", width: 100%, height: 100%)
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


#metadata("postlude end") <post-e>
