
<!-- templates -->

<!-- loading -->

<template id="template-loading">
    <img src="resources/images/loading.gif"/>
</template>

<template id="template-row-loading">
	<tr>
		<td><img src="resources/images/loading.gif"/></td>
	</tr>
</template>

<!-- loading -->

<!-- pagination -->

<template id="template-pagination-small">
    <nav class="center hide_if_large">
        <ul class="pagination">
            <li class="page-item"><a class="page-link translation" token="PREVIOUS" href="#" onclick="mPlugin.PreviousPage();">PREVIOUS</a></li>
            <li class="page-item"><a class="page-link" href="#">{{CURRENT_PAGE}}</a></li>
            <li class="page-item"><a class="page-link translation" token="NEXT" href="#" onclick="mPlugin.NextPage();">NEXT</a></li>
        </ul>
    </nav>
</template>

<template id="template-pagination-large-all-pages">
    <nav class="center show_if_large">
        <ul class="pagination">
            {{PAGES}}
        </ul>
    </nav>
</template>

<template id="template-pagination-large-page">
    <li class="page-item"><a class="page-link" href="#" onclick="mPlugin.ShowPage( {{PAGE}} );">{{PAGE}}</a></li>
</template>

<template id="template-pagination-large-page-current">
    <li class="page-item active"><a class="page-link" aria-current="page">{{PAGE}}</a></li>
</template>

<template id="template-pagination-large-page-next">
    <li class="page-item"><a class="page-link translation" token="NEXT" href="#" onclick="mPlugin.NextPage();">NEXT</a></li>
</template>

<template id="template-pagination-large-page-previous">
    <li class="page-item"><a class="page-link translation" token="PREVIOUS" href="#" onclick="mPlugin.PreviousPage();">PREVIOUS</a></li>
</template>

<!-- pagination -->

<!-- templates -->
