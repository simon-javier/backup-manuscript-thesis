#set text(font: "TeX Gyre Termes", size: 12pt)

#let font-size = 12pt
#let double-spacing = 1.5em


#let chp(title, hidden: false) = {
  show heading: none
  heading(level: 1, outlined: false, bookmarked: true)[#title]
  if not hidden {
    align(center)[*#upper(title)*]
  } else {}
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
  heading(level: 3)[#title]
  if not hidden {
    align(left)[*#upper(title)*]
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

#show heading.where(level: 5): it => emph(strong[#it.body.])



#show figure: set block(breakable: true, sticky: true)

#set figure(
  gap: double-spacing,
  numbering: "1.",
  placement: auto,
)

#set figure.caption(separator: none, position: bottom)

#show outline.entry.where(level: 1): it => link(it.element.location(), it.indented(strong(it.prefix()), it.inner()))

#show figure.caption: set align(center)
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
  width: auto,
  breakable: true,
  outset: (y: 7pt),
  radius: (left: 0pt, right: 6pt),
)

#show raw: set text(
  font: "Cascadia Code",
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
#let title = [PROBABILISTIC DETECTION OF SYSTEMIC DISEASES USING DEEP LEARNING ON FINGERNAIL BIOMARKERS]

#let title_page = context counter(page).display()
#page(header: none)[#align(center)[
    #{
      show heading: none
      [== Title Page]
    }

    #singleSpacing[*#title*]
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
    *BACHELOR OF SCIENCE IN COMPUTER SCIENCE*
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
    *MIA M. VILLARICA, DIT*
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

  The thesis entitled *"#title"* prepared and submitted by *GERON SIMON A. JAVIER*, *MHAR ANDREI C. MACAPALLAG*, and *SEANREI ETHAN M. VALDEABELLA* in partial fulfillment of the requirements for the degree of *BACHELOR OF SCIENCE IN COMPUTER SCIENCE*, major in *INTELLIGENT SYSTEM* is hereby recommended for approval and acceptance.
  \
  \
  \
  #grid(
    columns: (2fr, 1fr, 1fr),
    [], [], align(center)[*Mia M. Villarica* \ Thesis Adviser],
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
    [*MARIA LAUREEN B. MIRANDA* \ Member],
    text(size: 11pt)[*MA. CEZANNE D. DIMACULANGAN* \ Member],
    text(size: 11pt)[*ENGR. MARIBELLE B. MANALANSAN* \ Member],
    grid.cell(colspan: 2)[*REYNALEN C. JUSTO, LPT, DIT* \ Research Implement Unit Head],
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



#let toc = [
  #h2[Table of Contents]
  #h2(c: false)[Preliminaries]
  #outline(target: selector(heading).after(<prelim-s>).before(<prelim-e>), title: none)

  #h2(c: false, outlined: false, bookmarked: false)[CHAPTER I INTRODUCTION AND ITS BACKGROUND]
  #outline(target: selector(heading).after(<ch1-s>).before(<ch1-e>), title: none)

  #h2(c: false, outlined: false, bookmarked: false)[CHAPTER II REVIEW OF RELATED LITERATURE]
  #outline(target: selector(heading).after(<ch2-s>).before(<ch2-e>), title: none)

  #h2(c: false, outlined: false, bookmarked: false)[CHAPTER III RESEARCH METHODOLOGY]
  #outline(target: selector(heading).after(<ch3-s>).before(<ch3-e>), title: none)

  #h2(c: false, outlined: false, bookmarked: false)[CHAPTER IV RESULTS AND DISCUSSION]
  #outline(target: selector(heading).after(<ch4-s>).before(<ch4-e>), title: none)

  #h2(c: false, outlined: false, bookmarked: false)[CHAPTER V SUMMARY, CONCLUSIONS AND RECOMMENDATIONS]
  #outline(target: selector(heading).after(<ch5-s>).before(<ch5-e>), title: none)

  #outline(target: selector(heading).after(<post-s>).before(<post-e>), title: none, indent: 0em)

  #pagebreak()

  #h2[List of Figures]
  #outline(target: figure.where(kind: image), title: none)
  #pagebreak()

  #h2[List of Tables]
  #outline(target: figure.where(kind: table), title: none)


  #metadata("group 1 end") <prelim-e>
]

#toc


#pagebreak()

#show table.cell: set par(leading: 1em)
#show table.cell.where(y: 0): strong
#show table.cell.where(y: 0): upper
#set table(
  align: (_, y) => if y == 0 { center + horizon } else { left + horizon },
  stroke: (x, y) => (
    top: if y <= 0 { (thickness: 2pt, dash: "solid") } else if y <= 1 { (thickness: 1pt, dash: "solid") } else {
      (thickness: 0pt, dash: "solid")
    },
    bottom: (thickness: 2pt, dash: "solid"),
  ),
)

#set page(numbering: "1")
#counter(page).update(1)

#show heading.where(level: 1): it => align(center, strong(block(it.body)))
#show heading.where(level: 2): it => align(center, strong(block(it.body)))

#show heading.where(level: 3): it => block(it.body)

#show heading.where(level: 4): it => block(emph(it.body))

#show heading.where(level: 5): it => emph(strong[#it.body.])

#metadata("Chapter 1 start") <ch1-s>
#chp[Chapter I]
#h2(outlined: false, bookmarked: false)[Introduction and Its Background]
Fingernails are often referred to as a “window to systemic health,” as they can reveal early signs of serious conditions such as diabetes, cardiovascular diseases, and liver disorders through subtle changes in their appearance. These abnormalities, such as Beau’s lines (horizontal ridges indicating stress or illness), clubbing (enlarged fingertips linked to heart or lung issues), or pitting (small depressions associated with psoriasis or other systemic diseases), frequently appear before other symptoms become noticeable. Despite their diagnostic potential, these signs are commonly overlooked during routine medical checkups due to their subtle nature and the lack of specialized tools or training for general practitioners to identify them. This oversight delays early intervention, which could significantly improve health outcomes, particularly for individuals in underserved communities with limited access to advanced diagnostics.

The importance of accessible, non-invasive diagnostic methods cannot be overstated, as they empower individuals to monitor their health proactively and seek timely medical advice. However, many people worldwide face barriers to such healthcare services, including geographical isolation, financial constraints, and a lack of awareness about the significance of nail abnormalities. According to #cite(<gaurav_artificial_2025>, form: "prose"), fingernails are a globally recognized source of biomarkers due to their visibility and ease of examination, yet their potential in preventive healthcare remains largely untapped. This gap highlights the urgent need for innovative solutions that can bridge these barriers and democratize early disease detection.

Artificial Intelligence (AI) has emerged as a transformative force in addressing such healthcare challenges, particularly through advancements in image processing and probabilistic modeling. Deep learning techniques, such as Convolutional Neural Networks (CNNs), excel at analyzing visual data, identifying patterns that may escape human observation. For example, a hybrid Capsule CNN achieved a 99.40% training accuracy in classifying nail disorders, showcasing the potential of deep learning in this domain #cite(<shandilya_autonomous_2024>, form: "normal"). Similarly, a region-based CNN demonstrated superior performance to dermatologists in diagnosing onychomycosis, a common nail condition #cite(<han_deep_2018>, form: "normal"). However, these studies often focus solely on classifying nail abnormalities without linking them to underlying systemic diseases, limiting their practical impact on preventive care.

In the Philippines, early efforts like the Bionyx project (2018) explored AI-driven fingernail analysis, using Microsoft Azure Custom Vision to identify systemic conditions such as heart, lung, and liver issues through nail images. While innovative, its reliance on older technology resulted in limited precision compared to modern deep learning models #cite(<chua_student-made_2018>, form: "normal"). Internationally, research has emphasized the diagnostic value of nails, with studies employing machine learning techniques like Support Vector Machines and CNNs to enhance classification accuracy #cite(<dhanashree_fingernail_2022>, form: "normal"). Despite these advancements, a critical gap persists: the integration of deep learning-based classification with probabilistic inference to estimate the likelihood of systemic diseases, providing actionable insights for users.

This study aims to address this gap by developing a deep learning-based system that combines CNNs (e.g., ResNet, MobileNet, Efficent Net) for nail disorder classification with probabilistic models (e.g., Naïve Bayes, Bayesian Inference) to infer systemic disease probabilities. By using publicly available datasets from Kaggle and Roboflow, augmented with clinical health data, the system is designed to be a globally accessible, non-invasive tool for early health screening. The proposed system will empower individuals, regardless of their location or socioeconomic status, to monitor their health proactively, offering a user-friendly platform that delivers probabilistic risk assessments and actionable recommendations for medical consultation.

#pagebreak()
=== Research Problem

Systemic diseases such as diabetes, cardiovascular disorders, and liver conditions often manifest early through fingernail abnormalities, providing a critical window for intervention before more severe symptoms arise. These changes, such as discoloration, texture alterations, or structural deformities, are often subtle and require specialized knowledge to interpret, making them easy to overlook during standard medical evaluations. This delay in detection can lead to worsening health outcomes, particularly in areas with limited access to advanced diagnostics, where early intervention could be life-saving.

The advent of AI-driven technologies has shown promise in addressing this challenge by enabling accurate classification of fingernail disorders. For instance, a 2016 study achieved 65% accuracy in detecting diseases based on nail color analysis, but its scope was limited by ignoring texture and shape features #cite(<indi_early_2016>, form: "normal"). More recent studies, such as those employing advanced CNN models, have achieved higher accuracy in nail disorder classification, up to 99.40% in some cases, but they often stop at identifying nail conditions without linking them to systemic diseases #cite(<shandilya_autonomous_2024>, form: "normal"). This gap reduces the clinical utility of these systems, as they fail to provide comprehensive insights that could guide users toward appropriate medical action.

The potential of AI extends beyond healthcare into various sectors, demonstrating its versatility in addressing complex problems. In education, AI tools facilitate personalized learning experiences; in social services, they provide accessible resources to underserved populations; and in healthcare, they can enhance diagnostic accuracy, as seen in studies where CNNs outperformed dermatologists in diagnosing nail conditions #cite(<han_deep_2018>, form: "normal"). A system that integrates deep learning with probabilistic modeling could similarly revolutionize preventive healthcare by offering non-invasive screening to individuals worldwide, particularly those who lack access to specialized medical services. However, existing approaches often lack the ability to handle diagnostic uncertainty or provide interpretable results, limiting their effectiveness in real-world applications.

Moreover, the field of medical diagnostics has long sought non-invasive methods to improve early detection, with fingernails emerging as a promising biomarker due to their accessibility. #cite(<pinoliad_onyxray_2020>, form: "prose") demonstrated the feasibility of using machine learning for nail-based disease detection in the Philippines, but their system did not incorporate probabilistic inference for systemic diseases. This highlights the need for a more integrated approach that not only classifies nail disorders but also estimates the likelihood of underlying conditions, empowering users with actionable health insights.

Thus, this study specifically seeks to address the following problems:
+ How can a deep learning-based detection system be designed and implemented to utilize fingernail image biomarkers, probabilistic modeling, and clinical data for the accurate diagnosis of systemic diseases?

+ How can the functionality and accuracy of the developed detection system be tested in terms of classifying fingernail disorders and estimating the likelihood of systemic diseases using deep learning and probabilistic models?

+ How can the acceptability and usability of the fingernail-based disease detection system be evaluated among healthcare professionals and users at selected diagnostic clinics or health institutions?


=== Research Objectives
The main objective of this study is to design and develop a deep learning-based system for the probabilistic detection of systemic diseases using fingernail biomarkers, offering a non-invasive, accessible, and cost-effective solution to enhance preventive healthcare for individuals worldwide.

Specifically, this study seeks to achieve the following objectives:
+ To develop a deep learning-based detection system for systemic diseases using fingernail image biomarkers and probabilistic modeling, intended for use in preventive healthcare diagnostics.

+ To identify the best performing models for the system by assessing performance using standard evaluation metrics such as:
  + For CNN models (e.g., ResNet, MobileNet, EfficientNet):
    - Accuracy
    - Precision
    - Recall
    - F1-Score
  + For probabilistic models (e.g., Naïve Bayes, Bayesian Inference):
    - Confidence intervals
    - Sensitivity
    - Specificity

+ To examine the performance and usability of the developed disease detection system by conducting actual testing and evaluation among healthcare professionals at selected clinics or health centers.


=== Research Framework
This section outlines the theoretical and conceptual frameworks that underpin the study, providing a structured approach to developing the proposed system.

==== Theoretical Framework
#figure(
  image("img/theoretical-framework.png"),
  caption: [Integrated Deep Learning and Probabilistic Diagnostic Framework for \ Fingernail-Based Systemic Disease Detection],
)
The theoretical framework integrates deep learning and probabilistic modeling to create a comprehensive system for fingernail-based systemic disease detection, drawing inspiration from AI-driven diagnostic methodologies. It adapts principles from frameworks like #cite(<debnath_framework_2020>, form: "prose"), which emphasize systematic processing, feature extraction, and response generation in AI systems.

The process begins with users uploading fingernail images via a user interface, followed by input handling and preprocessing steps such as normalization, resizing, and augmentation to enhance image quality and variability. Feature extraction employs CNNs (e.g., ResNet, MobileNet) to identify visual patterns, while intent recognition classifies nail disorders (e.g., clubbing, pitting) and entity recognition isolates specific biomarkers. A knowledge integration module, populated with clinical literature and health data, supports probabilistic inference using models like Naïve Bayes and Bayesian Inference, generating risk assessments and recommendations. A feedback loop ensures continuous improvement by merging new data into the knowledge base, with third-party services providing external validation to enhance reliability.


#pagebreak()
==== Conceptual Framework
The conceptual framework provides a practical workflow for implementing the theoretical foundation, detailing the process from data collection to system deployment. It is divided into three phases: input, process, and output.

#figure(placement: none, image("img/ConceptualFramework.png"), caption: [Conceptual Framework of the Study])

The input phase involves collecting fingernail images from datasets like Kaggle and Roboflow, supplemented by local health data to inform probabilistic inference. The process phase includes data cleaning (normalization, noise reduction), segmentation to isolate fingernail regions, and augmentation (flipping, scaling, brightness adjustment) to enhance dataset diversity. Feature extraction using CNNs (e.g., ResNet, MobileNet, EfficientNet) precedes model training with a split dataset (80% training, 20% testing), employing CNNs for classification and probabilistic models (e.g., Naïve Bayes, Bayesian Inference) for inference. Evaluation metrics (sensitivity, recall, confidence intervals) guide hyperparameter tuning, leading to the selection of the best-performing model. The output phase delivers probabilistic classifications of nail disorders, systemic disease likelihoods (e.g., diabetes: 85%), and recommendations for medical consultation, with deployment into a mobile or web application for global accessibility.



=== Scope and Limitation of the Study
The general purpose of this study, titled "Probabilistic Detection of Systemic Diseases Using Deep Learning on Fingernail Biomarkers: A Preventive Healthcare Approach," is to develop an innovative and user-friendly system that leverages deep learning and probabilistic modeling to classify fingernail disorders and infer systemic diseases. The system aims to empower individuals globally by providing a non-invasive, accessible tool for early health screening, promoting preventive healthcare through early detection and actionable recommendations.

==== Scope and Coverage
The following identifies the scope and coverage of the study in terms of subject, methods, advanced technologies, features, output, target audience, and duration:

*Subject:* The research focuses on the classification of fingernail disorders and the probabilistic inference of systemic diseases, such as diabetes, cardiovascular diseases, and liver disorders, using fingernail biomarkers as a non-invasive diagnostic approach.

*Data Collection:* The study utilizes publicly available datasets from Kaggle and Roboflow, consisting of fingernail images with corresponding labels, augmented with clinical health data sourced from local health agencies to ensure relevance in probabilistic inference.

*Advanced Technologies:* The system employs deep learning techniques, specifically CNNs (e.g., ResNet, MobileNet, EfficientNet), for image classification, and probabilistic models (e.g., Naïve Bayes, Bayesian Inference) for systemic disease inference, ensuring high accuracy and interpretability.

*Features:* The system features an intuitive user interface that allows users to upload fingernail images, receive probabilistic classifications of nail disorders, and view estimated likelihoods of systemic diseases with recommendations for further medical evaluation. It also includes a feedback loop for continuous improvement.

*System Output:* The system provides probabilistic risk assessments in text format (e.g., "Clubbing: 98%, Diabetes Likelihood: 85%"), accompanied by actionable recommendations, fostering an informative interaction that enhances users’ understanding of their health risks.

*Target Audience:* The system targets a local and global audience, including individuals seeking proactive health monitoring, healthcare providers needing screening tools, and public health organizations aiming to monitor disease prevalence.

*Testing Group:* To assess its usability and reliability, the system will undergo testing with a diverse group, including non-medical individuals, healthcare professionals, and public health experts, ensuring it meets varied user needs.

*Time Duration:* The research is scheduled over a seven-month period, covering phases such as data collection, preprocessing, model development, training, testing, integration, evaluation, and deployment.

==== Limitations
However, this study is limited to the following:

*Dataset Quality and Balance:* The system’s performance relies on the quality and diversity of the training datasets, which may contain noise, inconsistencies, or class imbalances, potentially affecting its ability to generalize across diverse populations.

*Unverified Medical Annotations:* Publicly sourced datasets may lack formal verification from licensed medical professionals, introducing risks of inaccurate labels that could impact classification and inference reliability.

*Risk of Misclassification:* Errors in nail disorder classification may lead to inaccurate systemic disease probabilities, necessitating clear communication that the system serves as a preliminary screening tool, not a definitive diagnostic substitute.

*Computational Constraints:* Training complex CNN models requires substantial computational resources, which may limit the ability to explore advanced architectures, perform extensive hyperparameter tuning, or train for longer periods.

*Reliance on Image-Based Biomarkers:* The system depends solely on visual features from fingernail images, excluding other clinical indicators such as patient history, symptoms, or lab results, which are typically used in comprehensive medical diagnostics.

*Language Barrier:* While the system will include multilingual support, translation accuracy may vary, potentially affecting user understanding in non-English-speaking regions.

*Researcher Expertise:* The student-researcher’s current knowledge and programming skills may limit the system’s sophistication compared to state-of-the-art models developed by experienced professionals.

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
#set cite(form: "prose")
#chp[Chapter II]
#h2(outlined: false, bookmarked: false)[Review of Related Literatures]

This chapter provides a review of relevant research and literature from the various books, websites, magazines, and expertly developed principles to have improved comprehension of the research.  The literature is discussed in this chapter. and research projects undertaken by various scholars that have a substantial relationship to the way the study was conducted.  Those who were also a part of this chapter aids in familiarizing oneself with pertinent and comparable material to the current research.

=== Early Non-Invasive Diagnosis in Rural Settings
In a study conducted by #cite(<prajeeth_smart_2023>), he stated that nail disease is a common problem affecting millions of people worldwide, and some nail diseases can be a sign of internal systemic diseases. Diagnosis of nail diseases and internal systemic diseases at an earlier stage could potentially result in improved chances of recovery and extended lifespan.

Timely diagnosis is an important aspect in cutting down on death and enhancing treatment plans, especially with diseases like melanoma, which has very low survival rates if diagnosed late. However, referrals to dermatological specialists and dermatological technologies are frequently unavailable for patients living in rural or underdeveloped regions, and this is why effective automated diagnosis systems are called for #cite(<alruwaili_integrated_2025>, form: "normal").

The study of #cite(<yang_multimodal_2024>) supports this by stating that many diseases are left undiagnosed and untreated, even if the disease shows many physical symptoms. With the rise of Artificial intelligence (AI), self-diagnosis and improved disease recognition have become more promising than ever. AI-driven diagnostic systems can potentially improve the accuracy and speed of disease diagnosis, especially for skin diseases. These tools have shown promising results in the diagnosis of skin diseases, with some studies demonstrating superior performance compared to human dermatologists.

The urgency of research in personal hygiene and nail diseases is exceptionally high due to the significant health implications of untreated nail infections, which can range from minor discomfort to severe systemic health issues. Conducting in-depth research not only aids in identifying risk factors, transmission patterns, and effective prevention strategies but also supports the development of evidence-based interventions. These interventions are crucial for designing educational programs and health campaigns aimed at raising public awareness of the importance of proper nail care. #cite(<ardianto_bioinformatics-driven_2025>, form: "normal")

=== Nail Abnormalities as Systemic Disease Indicators
According to #cite(<abdulhadi_human_2021>), many diseases can be predicted by observing color and shape of human nails in healhcare domain. They stated that a white spot here, a rosy stain there, or some winkle or projection may be an indication of disease in the body. Problems in the liver, lungs, and heart can show up in nails. Doctors observe nails of patient to get assistance in disease identification. Usually, pink nails indicate healthy human. Healthy nails are smooth and consistent in color. Anything else affecting the growth and appearance of the fingernails or toenails may indicate an abnormality. A person’s nails can say a lot about their health condition. The need of such systems to analyze nails for disease prediction is because human eye is having subjectivity about colors, having limitation of resolution and small amount of color change in few pixels on nail not being highlighted to human eyes which may lead to wrong result, whereas computer recognizes small color changes on nail.

#cite(<dugan_management_2024>) observed a nail abnormality called Acral lentiginous melanoma (ALM). They stated that Acral lentiginous melanoma (ALM) is the rarest of the four major subtypes of cutaneous melanoma, accounting for 2-3% of all melanomas. ALM occurs predominantly in non-hair-bearing skin of the distal extremities, such as the palms of the hands, soles of the feet, and nailbeds. This unique histologic subtype was first described by RJ Reed in 1976, as pigmented lesions with a radial (lentiginous) growth phase of melanocytes, which evolves into a dermal (vertical) invasive stage. In addition to its distinctive growth pattern, ALM has additional characteristics separating it from non-ALM cutaneous melanoma. ALM has a much lower mutational burden than non- ALM cutaneous melanomas, including a lower incidence of activating mutations in BRAF and NRAS, variable KIT mutations, and a lack of ultraviolet (UV)-related mutational signatures. Mechanical stress such as pressure and trauma may play a role in the development of advanced ALM, especially in the lower extremities, but studies have reported conflicting evidence of this potential association. Diagnosing ALM is clinically challenging because it can mimic benign conditions such as ulcers, diabetes-related lesions, warts, or trauma.

Another example of nail abnormalities is described as Beau's Lines. In the paper called "Nail Abnormalities Clues to Systemic Disease" by #cite(<fawcett_nail_nodate>), they described Beau's lines as transverse linear depressions or grooves across the nail plate. They result from a transient decrease in mitotic activity of keratinocytes in the proximal nail matrix, causing temporary cessation of nail growth. The depth of the groove correlates with the degree of nail matrix damage, and its width indicates the duration of the insult. Beau's lines can be caused by any severe systemic illness or trauma that disrupts normal nail growth. Specific associations include severe acute illnesses such as fever, heart attack, pneumonia, measles, mumps, scarlet fever, coronary thrombosis, Kawasaki disease, and syphilis. Another causes are drug use, especially chemotherapeutics (e.g., doxorubicin, cyclophosphamide, docetaxel, cisplatin-fluorouracil, retinoids, carbamazepine, cloxacillin, dapsone, itraconazole), often affecting all 20 nails and appearing two to three weeks after therapy initiation. Trauma (local nail trauma, injuries to ipsilateral hand/wrist/elbow, nerve injury from fractures or carpal tunnel syndrome, limb immobilization) are also some of the possible causes of Beau's lines. Trauma-induced Beau's lines are typically unilateral. Raynaud’s disease, uncontrolled diabetes mellitus, zinc deficiency, and various dermatoses are associated to Beau's lines along with thyroid diseases and viral parotitis (mumps). Psychological stress and poor nutritional status are also one of the factors in having Beau's lines.

#cite(<lee_optimal_2022>) stated that Beau's Lines diagnosis is clinical, by inspecting the nail plate for transverse depressions. Ultrasound imaging can help visualize the defect and estimate the timeframe of the insult. AI models like AlexNet with Attention (AWA) have alse been applied to classify Beau's lines, achieving an 86.67% testing accuracy in the study conducted by #cite(<shih_classification_2022>).

Further down the list of nail abnormalities is called blue finger or cyanosis. #cite(<mahajan_artificial_2024>) described cyanosis as benign and rare condition with an idiopathic etiology. It is characterized by an acute bluish discoloration of fingers, which may be accompanied by pain. Blue fingers can mean your organs, muscles, and tissues aren’t getting the amount of blood they need to function properly. Many different conditions can cause cyanosis. Cyanosis is primarily caused by lower oxygen saturation, leading to an accumulation of deoxyhemoglobin in the small blood vessels of the extremities. It indicates a lack of oxygen. Central cyanosis may manifest on mucosa and extremities due to congenital heart diseases.  Peripheral cyanosis is typically diagnosed by examining the nails and digits, caused by vasoconstriction and diminished peripheral blood flow, as seen in cold exposure, shock, congestive cardiac failure, and peripheral vascular disease.

Another example of nail abnormalities is clubbing. #cite(<pankratov_nail_2024>) describes clubbing, also known as hippocratic nails, as fingers in the form of "drum sticks", a change in nails like "watch glasses". For the first time this type of onychodystrophy was described in the I century BC by Hippocrates in patients with pleural empyema. The curvature of the nail plate is strengthened in the transverse and anteroposterior directions, the free edge of the nail is often bent downwards.

=== Nail as Health Indicators
According to #cite(<shandilya_autonomous_2024>, form: "prose"), the architectural complexity of the nail unit proves to be an important marker for the general health condition and very often represents alterations coinciding with most diseases. Architectural changes in the nails constitute important diagnostic information within a broad spectrum of diseases-from cancer and dermatological diseases to respiratory and cardiovascular diseases. Their study develops an intricate classification system for nail diseases based on the anatomical characteristics of the nail unit for the enhancement of accuracy in dermatological diagnosis. Detailed diagnosis of nail diseases such as onychogryphosis, cyanosis, clubbing, and koilonychia enhances the accuracy of dermatological examination and alerts the clinician to more generalized health issues including hypoxia or anemia due to an iron deficiency. Besides, changes in nails may include manifestations like pitting in psoriasis or onycholysis in eczema: two diseases with a long duration.

Additionally, in the study of #cite(<indi_early_2016>, form: "prose"), different colors of nails indicate certain diseases. For example, Pink color nail indicate healthy nails which in turn indicates good health symptoms. White color nail means lack of iron and poor circulation, in which the blood is not reaching the end of your fingers, are resulting into white nails. It indicates anemic conditions or malnutrition. Moreover, a red-purple color nail means an upset digestive system caused by over consumption of sugar, pharmaceutical drugs, fruits and juices results into red-purple nails. When there are white spots in the nail, it indicate high content of sugar and lack of zinc which is required in the digestion process.


=== Limitations of Human Visual Diagnosis
Doctors observe nails of patient to get assistance in disease identification. The need of system to analyze nails for disease prediction is because human eye is having subjectivity about colors, having limitation in resolution and small amount of color change in few pixels on nail would not be highlighted to human eyes which may lead to wrong result where as computer recognizes small color changes on nail. #cite(<indi_early_2016>, form: "normal")


In addition, the study of #cite(<dhanashree_fingernail_2022>, form: "prose") mentions that though various disease can be diagnosed using the colour of finger nails, the accuracy rate sometimes fails. This is mainly due to the colour assumptions made by humans through naked eye. Human eye has limitation in resolution and small amount of colour change in few pixels on nail would not be highlighted to human eyes which may lead to wrong result whereas it is possible for a machine to recognize small colour changes on nail. The health condition can be diagnosed using the nail’s thickness, length of nails, colour and texture.

=== Deep Learning and Image Processing for Nail Analysis
The research conducted by #cite(<shandilya_autonomous_2024>, form: "prose") began with the development of a Base CNN model for nail disease classification and progressed to the creation of a more advanced Hybrid Capsule CNN model to improve classification performance. The integration of capsule networks into the Hybrid model significantly enhanced its ability to capture spatial hierarchies and handle transformations, leading to better overall classification outcomes. The Nail Disease Detection dataset has been employed to conduct the training and testing of both models. With an accuracy of 99.25%, the Hybrid Capsule CNN model provides a more accurate, robust, and dependable solution for automated nail disease classification then Base CNN model with 97.75% accuracy. Its potential applications extend to medical diagnostics and healthcare automation, where accurate disease detection is critical for effective treatment.

Furthermore, #cite(<ardianto_bioinformatics-driven_2025>, form: "prose") explored the application of Convolutional Neural Networks (CNNs) to detect 17 classes of nail conditions, achieving an overall detection accuracy of 83%. The CNN model, configured with predefined parameters such as a dropout rate of 0.2 and a learning rate of 0.001, demonstrated strong generalization capabilities. Notably, the dropout rate effectively reduced overfitting by introducing regularization, while the learning rate balanced convergence speed and stability during training. These parameter choices were instrumental in achieving a low validation error (0.1037) compared to training error, highlighting the model's ability to generalize to unseen data. Certain classes, such as "Leukonychia" and "Splinter Hemorrhage," showed excellent detection accuracy due to well-defined visual patterns in these conditions. However, classes like "Pale Nail" and "Alopecia Areata" exhibited lower accuracy, indicating the need for additional data and refinement in feature extraction. This highlights the model's strengths while also identifying areas requiring further research. The results underscore the potential of using CNN models in medical applications, providing a rapid and accessible diagnostic tool for nail condition detection.

In the study conducted by #cite(<lahari_cnn_2023>, form: "prose"), two algorithms for classification namely Artificial Neural Network and Convolution neural network (DenseNet121) were used. The two algorithms are compared based on accuracy, specificity, and sensitivity. ANN is the older version which is less accurate. CNN is the latest model which can perform the classification better and it gives better results than ANN. CNN gives more accuracy and sensitivity than ANN. And the specificity is almost equal in both the algorithms. In their proposed technique, they trained a model that classifies the disease based on the colour and pattern of the nail. The system detects the diseases based on the features. It is able to identify the small patterns and colour variations also such that providing a system with higher success rate. Their proposed model gives more accurate results than human vision, because it overcomes the limitations of human eye like to identify the variations in nail colour and patterns.

#cite(<archana_sharma_fingernail_2024>, form: "prose") conducted a fingernail image-based health assessment using a hybrid VGG16 and Random Forest Model. The hybrid model has proven to be highly effective in classifying fingernail images into specific disease categories. The model's performance, evaluated through metrics such as accuracy, precision, recall, and F1-score, exceeded those of alternative classifiers. With a 97.02% accuracy rate, the proposed model shows great promise for early diagnosis of diseases such as kidney disorder, melanoma, and anaemia through fingernail analysis. The proposed hybrid model has several advantages, including high accuracy and effective feature extraction through VGG16, making it highly reliable for disease detection. It is scalable, non-invasive, and versatile for other image-based diagnostics. However, its disadvantages include a limited dataset, and narrow disease focus. Future work can be focused on expanding the dataset, including more diseases, integrating the model into mobile applications, exploring advanced architectures like ResNet, and improving robustness to handle variable image quality for broader applicability.

Furthermore, in a study written by #cite(<han_deep_2018>, form: "prose"), although there have been reports of the successful diagnosis of skin disorders using deep learning, unrealistically large clinical image datasets are required for artificial intelligence  (AI) training. In their study, they created datasets of standardized nail images using a region-based convolutional neural network (R-CNN) trained to distinguish the nail from the background. They used R-CNN to generate training datasets of 49,567 images, which is then used to  fine-tune the ResNet-152 and VGG-19 models. The validation datasets comprised 100 and  194 images from Inje University (B1 and B2 datasets, respectively), 125 images from Hallym  University (C dataset), and 939 images from Seoul National University (D dataset).  The AI (ensemble model; ResNet-152 + VGG-19 + feedforward neural networks) results  showed test sensitivity/specificity/ area under the curve values of $(96.0 \/ 94.7 \/ 0.98), (82.7 \/ 96.7 \/ 0.95), (92.3 \/ 79.3 \/ 0.93), (87.7 \/ 69.3 \/ 0.82)$ for the B1, B2, C, and D datasets.  With a combination of the B1 and C datasets, the AI Youden index was significantly  $(p = 0.01)$ higher than that of 42 dermatologists doing the same assessment manually. For  $"B1"+C$ and $"B2"+D$ dataset combinations, almost none of the dermatologists performed as  well as the AI. By training with a dataset comprising 49,567 images, they achieved a diagnostic accuracy for onychomycosis using deep learning that was superior to that of most of the  dermatologists who participated in their study.

=== Subungual Melanoma
According to #cite(<emanuel_subungual_2023>, form: "prose"), Subungual melanoma is a cancer that arises from a malignant proliferation of melanocytes in the nail matrix. Typically, it presents clinically as a pigmented streak in the nail plate , which slowly expands at the proximal border and may extend to involve the adjacent nail fold.

In the study conducted by #cite(<holman_clinical_2020>, form: "prose"), Subungual melanomas (SUM) arise beneath the nails of the hands and feet, and account for 0.7–3.5% of all malignant melanomas. Most studies include SUM in the category of acral melanoma, but understanding the specific features of SUM is critical for improving patient care. In their study, they performed a site-specific comparison of the clinical and molecular features between 54 cases of SUM and 78 cases of nonsubungual acral melanoma. Compared to patients with acral melanoma, patients with SUM were younger at diagnosis, had a higher prevalence of primary melanomas on the hand, and had more frequent reports of previous trauma at the tumor site. SUM was deeper than acral melanoma at diagnosis, which correlated with an increased frequency of metastases. Analysis of common melanoma driver genes revealed KIT and KRAS mutations were predominantly found in SUM, whereas BRAF and NRAS mutations occurred almost exclusively in acral melanoma.

Subungual melanoma is most common in non-White race persons, with both men and women having equal risk, and requires the efforts of an interprofessional healthcare team. This team includes clinicians (MDs, DOs, NPs, and PAs), dermatological specialists, nursing staff, and pharmacists. Like other forms of melanoma, subungual melanoma can also spread to other parts of the body and is lethal. The key to diagnosis and early treatment is awareness. All healthcare team members, including nurses, should routinely examine the nails and maintain a high index of suspicion for any pigmented lesion on the nails. The only way to reduce the high mortality is an early referral to a dermatologist for a biopsy. Further, the nurse should educate patients on examining their skin and nails for unusual changes. Finally, both the nurse and the pharmacist should educate the public about using sunscreen when going outdoors and wearing protective clothing when going outdoors. Sunglasses are also recommended as the sun's UV rays can damage the retinal cells. #cite(<mole_subungual_2023>, form: "normal")

=== Beau's Line
Beau’s lines and onychomadesis were first described in 1846 and 1937, respectively. These nail dystrophies result from slowing or cessation of nail plate production following an insult to the nail matrix. In Beau’s lines, a slowing or temporary disruption of cell  growth from the nail matrix results in transverse grooves on the nail plate,  whereas  onychomadesis involves  complete separation of  the nail plate due to  cessation of nail plate production over 2–3 weeks. The 2 conditions can present independently or concurrently. #cite(<kim_beaus_2023>, form: "normal")

Moreover, according to #cite(<kim_beaus_2023>, form: "prose") Beau’s lines are transverse superficial grooves of the nail plate. The depression extends across width of the nail and is more visible in the middle part. It is more prominent on the thumb and great toe. Beau’s lines reflect a transitory damage to the proximal matrix with a decrease in the keratinocyte mitotic activity. The depth of the depression is related to the severity of the matrix injury and the length reflects the duration of the disease. This transverse depression appears 4 to 11 weeks after illness, allowing to date the event.This delay corresponds with the growth of the nail under the proximal nail fold. If it is located on several nails at the same level, a systemic cause is responsible and a thorough history often reveals the culprit.

Furthermore, in an article written by #cite(<cirino_what_2021>, form: "prose"), Beau’s lines are ridges that develop across the nails. They happen when nail growth is interrupted at the nail matrix. They can result from environmental factors and some medical issues. She stated that most people don’t pay much attention to their fingernails on a regular basis. Yet our fingernails are a big help to us in our everyday lives: They help us grip, scratch, separate things, and much more You might also be surprised to learn that the appearance of your fingernails can help you better understand you health. And in some cases, our nails may pinpoint specific health problems. One common nail deformation often indicating health trouble is Beau’s lines. Sometimes people mistakenly call these ridges forming across the nail “bows lines,” or “bow lines.” Beau’s lines occur when nail growth is interrupted at the nail matrix — the place where your nail emerges from your finger. Usually the cause of Beau’s lines is injury or severe illness, but in some cases, environmental factors may be to blame.

In addition, according to #cite(<agouridis_beaus_2024>, form: "prose"), Beau’s lines have been associated with several cutaneous conditions, systemic inflammatory diseases, and infections such as COVID-19. The findings of our systematic review suggest that Beau’s lines, an otherwise negligible clinical sign, may represent a potential indicator for severe immune response. Early identification and careful interpretation of these nail abnormalities can prove to be useful in recognizing patients with higher risk of long-lasting post-COVID-19 disease and in identifying patients with higher risk of severe COVID-19 re-infection.

=== Clubbing
In a study conducted by #cite(<hsu_automated_2024>, form: "prose"), he stated that lung and cardiovascular diseases are two of the leading causes of mortality worldwide, contributing to a significant global health burden. Research has increasingly shown that chronic pulmonary inflammation, whether localized or systemic, is closely associated with both lung and cardiovascular conditions. Despite their prevalence, the early detection of these diseases remains difficult due to the subtle and often asymptomatic nature of their initial stages. This delayed diagnosis frequently leads to disease progression, making these conditions more complex and harder to treat. One of the few early and visible clinical signs of both lung and cardiovascular diseases is digital clubbing. Digital clubbing is marked by a bulbous enlargement of the fingertips, a condition typically linked to a range of cardiopulmonary diseases, including lung cancer, chronic obstructive pulmonary disease (COPD), cyanotic congenital heart disease, and idiopathic pulmonary fibrosis. The pathophysiology of clubbing is thought to involve the release of platelet-derived growth factor (PDGF) and vascular endothelial growth factor (VEGF), which contribute to its manifestation and make it a valuable clinical marker for the early detection of cardiopulmonary diseases.

Moreover, finger clubbing is an important early clinical symptom indicating several sever health disorders, mostly related to cardio-pulmonary malfunctioning in human beings. Finger clubbing is identified as the deformation of the human finger into a bulbous tip appearance. This key clinical symptom is associated to several underlying health disorders including lung cancer. In the work of #cite(<dehavay_nail_2021>, form: "prose"), an automated, multi-parametric instrument has been developed for precise, quantitative and non-invasive diagnosis of finger clubbing that utilizes image processing and laser-photo-detector techniques for reliable diagnosis of finger clubbing. The automated instrument developed, has been used for diagnosis of finger clubbing in patients complaining of thoracic disorders and has showed reliable results.

Additionally, There are two principal signs of clubbing of the fingers, both of which are the result of proliferation of the tissue between the nail plate and underlying bone: 1. The normal nail plate makes an angle of 20°or more dorsalward with the axis of the finger. Diminution in this angle is evidence of clubbing and may be associated with increased convexity of the nail; 2. The Floating Nail sign, which is demonstrated by showing a “sponginess” or rebound when the base of the nail is compressed against underlying bone. #cite(<john_digital_2023>, form: "normal")

=== Terry's Nails
Terry’s nails are characterized by white opacification of the nails with effacement of the lunula and distal sparing. Described originally in 1954 by Dr. Richard Terry as a common fingernail abnormality in patients with hepatic cirrhosis, Terry’s nails are now a known sequelae of other conditions such as congestive heart failure, chronic kidney disease, diabetes mellitus, and malnutrition. Often all nails of the hands are affected. #cite(<lin_development_2021>, form: "normal")

Correspondingly, #cite(<rowe_nail_2025>, form: "prose") states that Terry's nails are characterized by leukonychia of nearly the entire nail bed, with only the distal 1 to 2 mm possessing a normal color. They are most commonly associated with hepatic cirrhosis, and in one multicenter study of patients with cirrhosis, 25.6% had Terry's nails.

On top of that, while being promoted as one of the most reliable physical signs of cirrhosis and early sign of autoimmune hepatitis, Terry's nails can also be an indication of chronic renal failure, congestive heart failure, hematologic disease, adult-onset diabetes mellitus, but also occur with normal aging. #cite(<chiacchio_atlas_2024>, form: "normal")

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
This study will be conducted at Laguna State Polytechnic University (LSPU), a state university located in the province of Laguna, Philippines. LSPU provides an academic environment conducive to scientific research, technological development, and community-centered innovation. The university's resources and academic community offer an appropriate setting for research involving artificial intelligence applications in public health.

The study focuses on the probabilistic detection of systemic diseases using deep learning on fingernail biomarkers, aiming to develop an application that enables early health risk screening. Conducting the research at LSPU ensures access to necessary computational tools, academic supervision, and local data insights relevant to the community.

The primary beneficiaries of this study are individuals seeking preventive healthcare in a convenient, accessible form. By designing the system to be user-friendly and deployable on digital platforms, the research addresses the growing demand for proactive health monitoring solutions. This includes not only residents of Sta. Cruz, Laguna and nearby areas but also any users with internet access who want to perform preliminary health assessments on the go.

Moreover, the research may serve as a valuable reference for future researchers, healthcare stakeholders, and technology developers interested in AI-driven solutions for early disease detection. By grounding the study in a local academic institution and addressing global health accessibility concerns, the project aims to contribute meaningfully to both scientific literature and real-world healthcare practices.

=== Applied Concepts and Techniques
This study integrates a wide range of machine learning and software engineering techniques to develop a reliable, scalable system for the probabilistic detection of systemic diseases through nail image classification. The applied concepts are grouped thematically to emphasize their specific roles in the system development lifecycle.

==== Deep Learning Fundamentals

*Convolutional Neural Networks (CNNs):* CNNs are the primary architecture for analyzing image data. They automatically learn spatial hierarchies of features—edges, textures, and shapes—that are essential for accurate classification of nail abnormalities.

*Vision Transformers (ViTs):* In addition to CNNs, Vision Transformers are explored for their ability to capture long-range dependencies and attention-based representations, which may enhance classification in complex image scenarios.

*Deep Learning:* The system utilizes deep neural networks capable of hierarchical representation learning, enabling end-to-end learning from raw images to disease classification output.

*Transfer Learning:* Pre-trained models such as EfficientNetV2 and RegNetY16GF, initially trained on large-scale datasets (e.g., ImageNet), were fine-tuned using the nail disease dataset to accelerate training and improve performance.

*Image Classification:* The core task involves classifying images into one of several disease categories, serving as the basis for subsequent probabilistic inference of systemic conditions.

==== Image Data Handling and Preprocessing
*Image Preprocessing: * Prior to training, images underwent resizing format conversion, augmentation, and normalization to ensure consistency across inputs and compatibility with model architectures.

*Normalization Input:* images were normalized using the standard ImageNet mean and standard deviation values: $"mean" = [0.485, 0.456, 0.406]$ and $"std" = [0.229, 0.224, 0.225]$. This normalization ensures compatibility with pre-trained models from PyTorch’s torchvision library, which were originally trained on the ImageNet dataset. By aligning the data distributions, normalization enables more effective transfer learning and stable gradient flow during training.

*Data Augmentation:* Techniques such as horizontal flipping, rotation, and brightness adjustment were applied to increase dataset diversity and reduce overfitting.

==== Training Optimization
*Batch Learning:* Training was conducted using mini-batches of 32 images per iteration. This method enhances training efficiency while maintaining a balance between generalization and convergence speed.

*Class Balancing:* To address class imbalance within the dataset, a weighted loss function was used. Class weights were assigned inversely proportional to the frequency of each class, ensuring that underrepresented classes contributed more significantly to the loss during training. This approach helped mitigate bias toward majority classes without altering the data distribution through sampling techniques.

*Learning Rate Scheduling:* Two strategies were employed to adaptively tune learning rates during training:
- _StepLR:_ Decreases the learning rate by a factor at fixed intervals.
- _ReduceLROnPlateau:_ Lowers the learning rate when validation metrics stop improving, allowing for more fine-grained convergence.

==== Model Evaluation and Interpretability
*Model Evaluation:* Performance was measured using standard metrics such as accuracy, precision, recall, and F1-score. Confusion matrices were also generated to evaluate per-class performance and misclassification trends.

*Visualization:* Plots of training/validation loss, accuracy curves, and confusion matrices were used to monitor and interpret model performance. Techniques such as Grad-CAM may also be explored to visualize model attention and improve transparency.

==== Software Engineering and System Design
*Modularization:* The system was structured into modular components—data preprocessing, model training, evaluation, and deployment—to facilitate maintenance, experimentation, and scalability.

=== Algorithm Analysis
To assess the performance and computational efficiency of the selected deep learning models, five architectures were evaluated using identical training parameters. Each model was trained for five epochs with a batch size of 32, a learning rate of $1e-4$, and the AdamW optimizer. The loss function employed was Cross Entropy Loss. All experiments were executed under consistent hardware and software environments to ensure comparability.

#figure(
  placement: none,
  text(size: 7pt)[
    #table(
      columns: (1fr,) * 8,
      align: (x, _) => if x == 0 { left + horizon } else { horizon + center },
      table.header(
        [Model], [Parameters], [Epochs], [Training Time (min)], [Accuracy], [Precision], [Recall], [F1-Score]
      ),

      [EfficientNetV2S], [20,190,298], [5], [21.22], [88%], [90%], [88%], [88%],

      [VGG16], [134,301,514], [5], [27.06], [66%], [77%], [66%], [67%],

      [ResNet50], [23,528,522], [5], [22.86], [75%], [80%], [75%], [76%],

      [RegNetY-16GF], [80,595,390], [5], [24.33], [85%], [88%], [85%], [85%],

      [SwinV2B], [86,916,068], [5], [62.13], [90%], [90%], [90%], [89%],
    )],
  caption: [Comparison of model performance metrics and training efficiency across nail conditions.],
)

// ==== Comparative Analysis
Among the five architectures, *SwinV2B* achieved the highest performance across all evaluated metrics, obtaining an accuracy of _90%_, precision of _90%_, recall of _90%_, and an F1-score of _89%_. Despite its computational intensity—demonstrated by the highest training time of _62.13 minutes_—its superior classification performance justifies the resource cost in scenarios where accuracy is prioritized.

*EfficientNetV2S* follows closely, with a relatively lower parameter count and faster training time, making it a competitive choice for lightweight applications. It achieves an F1-score of _88%_, while maintaining strong recall and precision.

In contrast, *VGG16*, the oldest architecture in this benchmark, demonstrated the lowest accuracy (_72%_) and F1-score (_70%_), coupled with the highest number of parameters. This result underscores its inefficiency for fine-grained classification tasks, such as fingernail disease detection, especially when compared to more modern architectures.

*ResNet50* and *RegNetY-16GF* exhibit balanced trade-offs between performance and computational requirements. *ResNet50*, with its residual connections, offers a solid baseline (F1-score: _76%_), while *RegNetY-16GF* leverages architectural flexibility to achieve higher metrics, albeit at increased parameter complexity.

==== Classification Breakdown
Individual classification reports are provided for each model, detailing per-class precision, recall, and F1-scores. These metrics are especially crucial given the dataset’s class imbalance and the medical significance of detecting less common conditions (_e.g., Koilonychia, Muehrcke’s Lines_).

#par(first-line-indent: 0em)[For example:]
- SwinV2B shows strong and consistent class-wise performance, particularly achieving *1.00 recall* for _Acral Lentiginous Melanoma_ and _Muehrcke’s Lines_, which is critical in a preventive diagnostic context.
- VGG16 struggles with minority classes such as _Blue Finger_ and _Beau’s Line_, exhibiting high variance and frequent underperformance.
- ResNet50 shows improvement in difficult classes like _Blue Finger_ (F1: *0.78*) and _Pitting_ (F1: *0.89*), albeit at lower recall for others like Clubbing.

These reports indicate that while newer models offer significantly improved overall accuracy, their strength also lies in more balanced performance across all classes.


=== Data Collection Methods
The dataset utilized for this study is sourced from a publicly available Nail Disease Detection collection hosed on Roboflow, and is released under the Creative Commons Attribution 4.0 (CC BY 4.0) license. The dataset comprises a total of 7,264 images, annotated using the TensorFlow TFRecord (Raccoon) format, covering 11 classes of nail diseases. However, the researchers have dropped the Lindsay's Nail class due to few number of images.

The final dataset used in this study consists of 7,258 labeled nail images, divided into three subsets: training (6,360 images, 88%), validation (591 images, 8%), and testing (307 images, 4%).

Each subset contains images from ten nail disease classes, with class distributions reflecting a natural imbalance. The training set is used for model learning, the validation set for hyperparameter tuning and early stopping, and the test set for final evaluation.

The class with the highest representation across all sets is Terry's Nail, while Muehrcke’s Lines is the most underrepresented. The breakdown of samples per class in each subset is as follows:

#figure(
  placement: none,
  table(
    columns: (1.7fr, 1fr, 1fr, 1fr),
    align: (x, _) => if x == 0 { left + horizon } else { horizon + center },
    table.header([Class], [Train], [Validation], [Test]),

    [Acral Lentiginous Melanoma], [753], [70], [36],
    [Beau's Line], [456], [44], [22],
    [Blue Finger], [612], [59], [29],
    [Clubbing], [783], [74], [38],
    [Healthy Nail], [642], [54], [30],
    [Koilonychia], [537], [52], [28],
    [Muehrcke’s Lines], [336], [31], [16],
    [Onychogryphosis], [690], [65], [34],
    [Pitting], [657], [61], [32],
    [Terry’s Nail], [894], [81], [42],
  ),
  caption: [Sample distribution per class across dataset splits.],
)

Weighted loss was used during training to compensate for class imbalance and improve model fairness across underrepresented classes.

The dataset we collected were already pre-processed and augmented. These were the preprocessing step used by the owner of the public dataset:
- Automatic orientation correction (EXIF metadata removed)
- Resizing to $416 #sym.times 416$ pixels using "fit" scaling, which introduces black padding to maintain aspect ratio

To improve model generalization, data augmentation was also applied, producing three versions of each source image. These augmentations included:
- 50% chance of horizontal flip
- 50% chance of vertical flip
- Equal probability of a 90-degree rotation (none, clockwise, counter-clockwise, or 180°)
- Random rotation within the range of -15° to +15°
- Random shear transformations between -15° and +15° in both horizontal and vertical directions
- Random brightness adjustment between -20% and +20%
- Random exposure adjustment between -15% and +15%

Although the dataset was initially preprocessed and augmented through Roboflow's pipeline, additional preprocessing steps were performed to ensure compatibility with the PyTorch deep learning framework. Specifically, all images were resized to $224 × 224$ pixels, which is the standard input dimension for most pre-trained Convolutional Neural Network (CNN) architectures in PyTorch.

Each image was then converted into a tensor format to facilitate numerical computation during training and inference. Furthermore, normalization was applied using the mean and standard deviation values commonly used by PyTorch’s pre-trained models on the ImageNet dataset. This normalization ensures consistency in input distribution, allowing for more stable and efficient model convergence.

These preprocessing steps were essential for adapting the dataset to the specific requirements of the chosen model architectures and the deep learning environment used in this study.

=== Data Model Generation

=== System Development Methodology
The models are trained using google colab. It is then integrated into django for web interfaces

=== Software Tools Used
The development, training, evaluation, and deployment of the proposed system utilized a suite of open-source and industry-standard software tools, ensuring both reproducibility and scalability of the research. The following tools and frameworks were employed:

*Python:* The primary programming language used throughout the study for data processing, model development, and system integration due to its extensive support for machine learning and scientific computing.

*PyTorch:* A deep learning framework used for implementing, training, and fine-tuning convolutional neural networks (CNNs) and vision transformers. PyTorch enabled seamless integration with pre-trained models, dynamic computation graphs, and GPU acceleration.

*Torchvision:* A PyTorch companion library used for loading pre-trained models (e.g., EfficientNetV2, RegNetY16GF, ResNet50), applying standard image transformations, and accessing utility functions for computer vision tasks.

*Torchmetrics:* A PyTorch-native library for computing evaluation metrics such as accuracy, precision, recall, and F1-score. Its modular design ensured consistent metric computation across training, validation, and testing phases.

*Google Colab:* A cloud-based Jupyter notebook environment used for training and experimentation. It provided access to free GPU resources (T4) essential for efficient model training.

*Matplotlib & Seaborn:* Visualization libraries used to plot training metrics (loss, accuracy), confusion matrices, and Grad-CAM outputs for model interpretability and evaluation.

*Grad-CAM:* Applied to generate class activation maps that explain the visual reasoning behind model predictions, enhancing interpretability and transparency.

*Pandas & NumPy:* Used for data manipulation, statistical computation, and label handling throughout preprocessing and evaluation.

*Scikit-learn:* Employed for computing evaluation metrics such as precision, recall, F1-score, and for generating confusion matrices.

*Visual Studio Code:* The primary development environment used for writing and organizing code modules. Its extensions for Python and Git integration facilitated version control and modular code development.

*Django:* A high-level Python web framework intended for integrating the trained model into a web application, enabling users to upload nail images and receive probabilistic health feedback.

=== System Architecture

=== Software Testing

#pagebreak()
#metadata("Chapter 3 end") <ch3-e>

#metadata("Chapter 4 start")<ch4-s>
#chp[Chapter IV]
#h2(outlined: false, bookmarked: true)[Results and Discussion]

=== System Overview

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


#show heading: none
#text(size: 60pt)[#align(center + horizon)[*Appendices*]]
#metadata("postlude end") <post-e>
