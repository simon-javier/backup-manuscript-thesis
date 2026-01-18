// NOTE: INSTALL FONTS IN THE `fonts/` FOLDER
#set page(
  
  margin: (top: 2in, x: .8in, y:1in),
  header: [
    #grid(
      align: center,
      gutter: 1fr,
      columns: (1fr, 4fr, 1fr),
      grid.cell(image("LSPULogo.png", width: 0.9in)),
      grid.cell(align(horizon + center)[
        #text(size: 10pt)[Republic of the Philippines]\
        #text(font: "Old English Text MT", size: 14pt)[Laguna State Polytechnic University]\
        #text(size:10pt)[Province of Laguna]
      ]),
      grid.cell(image("College of Computer Studies.png", width: 0.9in)),
    )
  ],
  numbering: "1",
  number-align: right,
)

#set text(font: "Arial", size: 12pt)

#grid(
  columns: (1fr, 3fr),
  row-gutter: 1em,
  [Group Code:], [CS4B-05],
  [Student Name:], [1. Javier, Geron Simon A.\
2. Macapallag, Mhar Andrei C.\
3. Valdeabella, Seanrei Ethan M.\
],
  [Date Approved:], [April 15, 2025],
  [Title:], [Probabilistic Detection of Systemic Diseases Using Deep Learning on Fingernail Biomarkers],
  [Adviser:], [Mia V. Villarica],
)

#show rect: set text(fill: rgb("#fff"), size: 16pt, weight: "bold", font: "Calibri")
#rect(
  fill: rgb(0, 32, 96),
  width: 100%,

  align(center)[MATRIX OF COMPLIANCE]
)

#show table.cell: it => {
  set text(size: 11pt)
  if it.y == 0 {
    strong(it)
  } else {
    it
  }
}
#table(
  columns: (.9fr, .9fr, 0.5fr, 0.9fr),
  align: (x, y) => if y == 0 { center + horizon } else if x == 2 { center + horizon } else {left},
  table.header(
    [RECOMMENDATIONS],
    [ACTION TAKEN],
    [STATUS],
    [PANEL'S APPROVAL],
  ),

  table.cell(colspan: 4, fill: rgb(213, 220, 228), )[*SUMMARY OF RECOMMENDATIONS FROM TITLE PROPOSAL LAST APRIL 15*],
  [1. Verify dataset from experts], 
  [The dermatologist verified our dataset. She clarified that the images are nail features. She also clarified that Acral Lentiginous Melanoma is not a nail feature but a diagnosis itself, and the nail feature or physical examination finding can be hyperpigmented nail plate or melanonychia.], 
  [Fully Complied], 
  [],

  [2. Consult experts on the field], 
  [Interviewed a dermatologist from Laguna Holy Family Doctors], 
  [Fully Complied], 
  [],

  [3. Consider external factors like age, history, and lifestyle], 
  [We are including demographical statistics gathered from literature. Data availability can be a challenge ], 
  [Partially Complied], 
  [],

  [4. Curate local dataset of nail images], 
  [Since nail features are morphologically consistent across the world but the prevalence is not, we will curate a local dataset of statistics to be used for Bayesian inference], 
  [Partially Complied], 
  [],

  [5. Remove the "Sta. Cruz" from the title], 
  [Removed the "Sta. Cruz" from the title], 
  [Fully Complied], 
  [],

  [6. Consider color changes on the skin], 
  [The dataset we gathered includes color changes. Blue Nails, Terry's Nails, and Muehrcke's Lines have these color changes ], 
  [Fully Complied], 
  [],

  table.cell(colspan: 4, fill: rgb(213, 220, 228), )[*DR. MIA VILLARICA - THESIS ADVISER (RECOMMENDATIONS FROM RC)*],

  [1.	Specific objectives should be informed.],
  [We specified the research problem and research objectives. The data to be collected is articulated more clearly. The research problem takes on a more specific approach in terms of data collection methods and training and evaluation methods. The research objectives reflect these research problems.],
  [Fully Complied],
  [],

  [2.	The theoretical framework should be revised as well],
  [Included more theories, concepts, and models that explains why we chose certain approach.],
  [Fully Complied
  ],
  [],

  [3.	The conceptual framework is good, however, this should be aligned with the specific objectives],
  [Made minor changes in the conceptual framework to align with the specific objectives],
  [Fully Complied],
  [],

  [4.	List the nail attributes and correlate diseases],
  [Listed nail attributes with their corresponding image and description.],
  [Fully Complied],
  [],

  [5.	Strengthen the RRL],
  [Reviewed more literature to further strengthen the RRL. We then synthesized based on the gaps that we found.],
  [Fully Complied],
  [],

  [6.	Improve the docoument manuscript: Chapter 3],
  [Included photos and descriptions of the 10 nail features which was not included in the last defense. The _Applied Techniques_ section now includes all the techniques being used by the researchers with images of the techniques.],
  [Fully Complied],
  [],

  [7.	Improve the scope and limitation],
  [The scope and limitation is now made to be more specific and now aligns with the research problem and objectives. We also added delimitations to state which parts or methods of the research we intentionally did not include.],
  [Fully Complied],
  [],

  table.cell(colspan: 4, fill: rgb(213, 220, 228), )[*MICAH JOY FORMARAN - TECHNICAL EDITOR (RECOMMENDATIONS FROM RC)*],

  [1.	Refrain from dividing words. Example: discol- \
  oration should be one word "discoloration"
  ],
  [Turned off automatic hyphenation in the document.],
  [Fully Complied],
  [],

  [2.	Table captions should be placed above the table.],
  [Repositioned all table captions above their respective tables.],
  [Fully Complied],
  [],

  table.cell(colspan: 4, fill: rgb(213, 220, 228), )[*DR. MIA VILLARICA - (ADDITIONAL RECOMMENDATIONS LAST AUGUST 19)*],

  [1. Find literature or expert opinions supporting the proposed renaming of ‘Acral Lentiginous Melanoma’ to ‘Melanonychia.’],
  [Incorporated expert opinion from Dr. Cristine Florentino to justify renaming the class.],
  [Fully Complied],
  [],

  [2. The objectives should be revised to make them more specific and measurable, such as specifying the exact number of images, confirming whether each image is labeled, and detailing the verification process.],
  [
   - Made the objectives more specific
   - Specified minimum number of images of the dataset, as well as the resolution.
   - The dataset to be gathered must be a labeled dataset
  ],
  [Fully Complied],
  [],

  [3. The definition of “high-quality” images should be removed.],
  [- Removed],
  [Fully Complied],
  [],

  [4. The planned use of Roboflow or synthetic datasets should be explicitly included in the objectives, with a clear explanation of where and how they will be applied in the project.],
  [- Explained how the dataset will be applied in the project. It will be applied for deep learning],
  [Fully Complied],
  [],

  [5. The project timeline should be updated and adjusted to align with the suggested defense dates (October 6–10 or December 1–5) to make it more realistic and well-defined.],
  [],
  [Fully Complied],
  [],

  table.cell(colspan: 4, fill: rgb(213, 220, 228), )[*MARK BERNARDINO - SYSTEM EXPERT (ADDITIONAL RECOMMENDATIONS LAST SEPTEMBER 5)*],
  [1. If the system can detect nail features with 60% accuracy above, just focus on predicting the underlying sysytemic diseases for now],
  [ - Curated a dataset of statistics of systemic diseases
    - Applied Bayes' Theorem for probabilistic prediction
  ],
  [Fully Complied],
  [],

  [2. Document all the experiments],
  [- Started adding screenshots of code in Data Model Generation and in drafts chapter 4.],
  [Ongoing],
  [],

  [3. Scale the classifier's confidence with the confusion matrix when predicting the probability of systemic diseases],
  [Started making a prototype for this functionality.],
  [Fully Complied],
  [],

  [4. Make a mobile version if possible],
  [],
  [Not started],
  [],

)

Noted:

*MARIA LAUREEN B. MIRANDA* \
CCS - RIUH

