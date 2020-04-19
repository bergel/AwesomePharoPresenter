"
AwesomePharoPresenter new openWithSpec

"
Class {
	#name : #AwesomePharoPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'list',
		'label',
		'actionBar',
		'selectedItem',
		'urls'
	],
	#category : #AwesomePharo
}

{ #category : #specs }
AwesomePharoPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: 'Awesome projects' withConstraints: [ :constraints | constraints height: self labelHeight ];
		add: #list;
		add: #label withConstraints: [ :constraints | constraints height: self labelHeight ];
		add: #actionBar withConstraints: [ :constraints | constraints height: self buttonHeight ];
		yourself
]

{ #category : #'instance creation' }
AwesomePharoPresenter class >> menuCommandOn: aBuilder [
	"Add a custom menu item to the world menu"

	<worldMenu>
	(aBuilder item: #'Awesome Pharo')
		order: 201;
		iconName: #catalogIcon;
		parent: #Tools;
		help: 'List of Awesome Pharo Projects';
		action: [ self open ]
]

{ #category : #'instance creation' }
AwesomePharoPresenter class >> open [
	<script: 'self open'>
	| window |
	window := self new openWithSpec.
	window title: 'Awesome Pharo'.
	^ window
]

{ #category : #initialization }
AwesomePharoPresenter >> connectPresenters [
	list
		whenSelectionChangedDo: [ :selection | 
			[ :elem | 
			selectedItem := elem.
			label
				label:
					(elem
						ifNil: [ 'Deselection from list' ]
						ifNotNil: [ 'Selection from list: ' , elem asString ]) ]
				cull: selection selectedItem ].

]

{ #category : #initialization }
AwesomePharoPresenter >> initializePresenters [
	list := self newList.
	label := self newLabel.
	
	list items: self itemsFromAwesomePharoWebpage.
	label label: 'No selection'.
	
	actionBar := self newActionBar
		add: (self newButton
					label: 'Jump to GitHub';
					icon: (self iconNamed: #smallOk);
					action: [ self jumpToGitHub ] );
		add: (self newButton
					label: 'Help';
					icon: (self iconNamed: #help);
					action: [ self openHelp ] )
]

{ #category : #initialization }
AwesomePharoPresenter >> itemsFromAwesomePharoWebpage [
	"self new itemsFromAwesomePharoWebpage"
	| pageContent relevantLines projectName description result |
	pageContent := (ZnEasy get: 'https://raw.githubusercontent.com/pharo-open-documentation/awesome-pharo/master/README.md') contents.
	relevantLines := pageContent lines select: [ :l | l prefixMatchesRegex: '\+\s\[\w*\]\(https' ].
	
	urls := Dictionary new.
	result := relevantLines collect: [ :l |
		projectName := (l substrings: '[]') second.
		urls at: projectName put: (l substrings: '()') second.
		description := l copyFrom: (l indexOfSubCollection: ' - ') + 3 to: l size.
		projectName, ' - ', description
	].
	^ result sortedAs: [ :l1 :l2 | l1 < l2 ]
	
]

{ #category : #initialization }
AwesomePharoPresenter >> jumpToGitHub [

	| aUrl |
	aUrl := urls at: (selectedItem substrings: '-') first trimRight.
	WebBrowser openOn: aUrl
]

{ #category : #initialization }
AwesomePharoPresenter >> list [
	^ list
]

{ #category : #initialization }
AwesomePharoPresenter >> openHelp [
	UIManager default alert: 'Description of AwesomePharo may be found on https://github.com/pharo-open-documentation/awesome-pharo'
]
