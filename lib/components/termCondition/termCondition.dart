// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class Termscreen extends StatefulWidget {
  const Termscreen({super.key});

  @override
  State<Termscreen> createState() => _TermscreenState();
}

class _TermscreenState extends State<Termscreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            title: const Text('Terms & Conditions'),
            leading: IconButton(
                onPressed: () => print('retour pressed'),
                icon: const Icon(Icons.arrow_back)),
          ),
          body: const Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                "A l'ère de l'évolution technologique, l'informatique s'affirme comme un pilier essentiel du développement des entreprises, qu'elles soient grandes, moyennes ou plus modestes. Conçue pour répondre aux besoins humains, cette discipline englobe un éventail impressionnant de fonctions essentielles : enregistrer, stocker, traiter, organiser, transmettre et présenter l'information dans des formats faciles à utiliser. Par conséquent, l'informatique joue un rôle important pour surmonter les obstacles rencontrés par les entreprises, les guidant vers le succès et la prospérité. C'est dans ce contexte que s'est déroulé notre stage au Centre VALBIO de Ranomafana. Notre mission est de concevoir et réaliser une application de gestion spécifiquement destinée à la gestion des chercheurs, visiteurs scientifiques et étudiants internationaux de cette institution. Auparavant, le centre utilisait un système de gestion manuel basé sur une base de données Excel, ce qui entraînait des défis tels que la perte de données, la journalisation des erreurs et la complexité des procédures, La condition d’accès en première année de Master (M1) en S7 se fait par sélection  de dossier après l’obtention du diplôme de Licence en Administration Economique et Sociale,  en Gestion ou en Economie.La mention Management propose un parcours Management Décisionnel ayant pour  objectif de former et d’équiper les apprenants à la maîtrise des outils d’aide à la décision en  matière de management et de leur donner les compétences requises dans ce domaine. Comme  le management a besoin de se conformer en permanence aux diverses nouvelles exigences du  marché, l’enseignement doit alors toujours viser pour mettre à jour les connaissances de  l’apprenant par la formulation de programmes de cours qui tiennent compte de ces nouveautés.  Ainsi, les objectifs principaux peuvent se résumer à former des acteurs de haut niveau en  management décisionnel, de préparer des cadres capables de gérer et de créer un projet de  développement économique régional et national.  Les sortants peuvent travailler dans les secteurs privés et publics des différentes  régions de Madagascar en tant que chefs de conduite de travaux d’enquêtes communautaires,  concepteurs de projets, chefs de services ou directeurs d’entreprises. Dans ce cas, les étudiants  sortants sont capables de créer une petite entreprise, de monter un projet de développement  rural et de gérer un grand projet.  "),
                          ],
                        ))),
              ],
            ),
          )),
    );
  }
}
