<%--
/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/journal/init.jsp"%>

<%
	AssetRenderer assetRenderer = (AssetRenderer) request.getAttribute(WebKeys.ASSET_RENDERER);
	int abstractLength = (Integer) request.getAttribute(WebKeys.ASSET_PUBLISHER_ABSTRACT_LENGTH);

	JournalArticle article = (JournalArticle) request.getAttribute(WebKeys.JOURNAL_ARTICLE);
	JournalArticleResource articleResource =
		JournalArticleResourceLocalServiceUtil.getArticleResource(article.getResourcePrimKey());

	String languageId = LanguageUtil.getLanguageId(request);

	boolean workflowAssetPreview = GetterUtil.getBoolean((Boolean) request.getAttribute(WebKeys.WORKFLOW_ASSET_PREVIEW));

	JournalArticleDisplay articleDisplay = null;

	if (!workflowAssetPreview && article.isApproved()) {
		articleDisplay =
			JournalContentUtil.getDisplay(
				articleResource.getGroupId(), articleResource.getArticleId(), null, null, languageId, themeDisplay);
	}
	else {
		articleDisplay =
			JournalArticleLocalServiceUtil.getArticleDisplay(article, null, null, languageId, 1, null, themeDisplay);
	}

	boolean isMaximized = ParamUtil.getBoolean(request, "isMaximized");
	boolean isStories = ParamUtil.getBoolean(request, "isStories");
	boolean readMoreLink = ParamUtil.getBoolean(request, "readMoreLink");
%>

<c:if test="<%= (isStories && !readMoreLink) || (isStories && isMaximized && readMoreLink) %>">

	<%
		String src = StringPool.BLANK;

			if (articleDisplay.isSmallImage()) {
				if (Validator.isNotNull(articleDisplay.getSmallImageURL())) {
					src = articleDisplay.getSmallImageURL();
				}
				else {
					src =
						themeDisplay.getPathImage() + "/journal/article?img_id=" + articleDisplay.getSmallImageId() + "&t=" +
							WebServerServletTokenUtil.getToken(articleDisplay.getSmallImageId());
				}
			}
			else {
				src = themeDisplay.getPathThemeImages() + "/custom/default_stories.jpg";
			}
	%>

	<div class="asset-small-image">
		<img alt="" class="asset-small-image" src="<%=HtmlUtil.escape(src)%>" width="191" />
	</div>
</c:if>

<%
	String summary = articleDisplay.getDescription();

	if (Validator.isNull(summary)) {
		summary = StringUtil.shorten(HtmlUtil.stripHtml(articleDisplay.getContent()), abstractLength);
	}
%>

<%=summary%>