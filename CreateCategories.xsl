<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="xsi">

    <!--
       - Main template for the parent folder of the folders & lists structure
       -
       - Edit the XPath so it matches your folder structure. Please, note that
       - this XPath needs to match the Items node inside the target folder.
       -
       - Example:
       -    Let's say you want your folders saved on
       -    /Comics/Reviewed/Catalog
       -
       -    Use this value for match
       -    match='//ComicLists/Item[@Name="Comics"]/Items/Item[@Name="Reviewed"]/Items/Item[@Name="Catalog"]/Items'
    -->
    <xsl:template match='//ComicLists/Item[@Name="Catalogados"]/Items'>
        <Items>
            <Item xsi:type="ComicListItemFolder" Name="OneShot">
                <NewBookCountDate/>
                <CacheStorage/>
                <Display/>
                <xsl:call-template name="createOneshotsFolder" />
            </Item>
            <Item xsi:type="ComicListItemFolder" Name="Series">
                <NewBookCountDate/>
                <CacheStorage/>
                <Display/>
                <Items>
                    <Item xsi:type="ComicListItemFolder" Name="Limited">
                        <NewBookCountDate/>
                        <CacheStorage/>
                        <Display/>
                        <xsl:call-template name="createSeriesLimitedFolder" />
                    </Item>
                    <Item xsi:type="ComicListItemFolder" Name="Complete">
                        <NewBookCountDate/>
                        <CacheStorage/>
                        <Display/>
                        <xsl:call-template name="createSeriesCompleteFolder" />
                    </Item>
                    <Item xsi:type="ComicListItemFolder" Name="Incomplete">
                        <NewBookCountDate/>
                        <CacheStorage/>
                        <Display/>
                        <xsl:call-template name="createSeriesIncompleteFolder" />
                    </Item>
                </Items>
            </Item>
            <Item xsi:type="ComicListItemFolder" Name="Arcs">
                <NewBookCountDate/>
                <CacheStorage/>
                <Display/>
                <Items>
                    <Item xsi:type="ComicListItemFolder" Name="Complete">
                        <NewBookCountDate/>
                        <CacheStorage/>
                        <Display/>
                        <xsl:call-template name="createArcsCompleteFolder" />
                    </Item>
                    <Item xsi:type="ComicListItemFolder" Name="Incomplete">
                        <NewBookCountDate/>
                        <CacheStorage/>
                        <Display/>
                        <xsl:call-template name="createArcsIncompleteFolder" />
                    </Item>
                </Items>
            </Item>
        </Items>
    </xsl:template>



    <!-- Create the Folder for Oneshots -->
    <xsl:template name='createOneshotsFolder'>
        <xsl:message>ONESHOTS</xsl:message>
        <Items>
            <xsl:for-each select='//Book/Series[not(.=preceding::Book/Series)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createOneshotsItem" >
                    <xsl:with-param name="series"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>

    <!-- Creates the dynamic lists for One-shots
       -
       - A One-shot series:
       -     has only one book
       -     SeriesCount is 1
       -
       - @param series {string} Series name
       -->
    <xsl:template name="createOneshotsItem">
        <xsl:param name="series" />
        <xsl:if test="count(//Book[Series=$series]) = 1 and ../Count=1">
            <xsl:call-template name="createDynamicList">
                <xsl:with-param name="listName"><xsl:value-of select="$series"/></xsl:with-param>
                <xsl:with-param name="matcher">ComicBookSeriesMatcher</xsl:with-param>
                <xsl:with-param name="matchOperator">6</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>





    <!-- Create the Folder for Series/Limited -->
    <xsl:template name='createSeriesLimitedFolder'>
        <xsl:message>SERIES/LIMITED</xsl:message>
        <Items>
            <xsl:for-each select='//Book/Series[not(.=preceding::Book/Series)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createSeriesLimitedItem" >
                    <xsl:with-param name="series"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>

    <!-- Creates the dynamic lists for limited series.
       -
       - A Limited Series:
       -     has more between 2 and 12 comics (inclusive)
       -     has more or equal comics than the SeriesCount or has been marked with SeriesComplete
       -     or has been marked with Format = 'Limited Series'
       -
       - @param series {string} Series name
       -->
    <xsl:template name="createSeriesLimitedItem">
        <xsl:param name="series" />
        <xsl:if test="(count(//Book[Series=$series])>1 and (count(//Book[Series=$series])>=number(../Count) or ../SeriesComplete='Yes') and 12>=number(../Count)) or ../Format='Limited Series'">
            <xsl:call-template name="createDynamicList">
                <xsl:with-param name="listName"><xsl:value-of select="$series"/></xsl:with-param>
                <xsl:with-param name="matcher">ComicBookSeriesMatcher</xsl:with-param>
                <xsl:with-param name="matchOperator">0</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>





    <!-- Create the Folder for Series/Complete -->
    <xsl:template name='createSeriesCompleteFolder'>
        <xsl:message>SERIES/COMPLETE</xsl:message>
        <Items>
            <xsl:for-each select='//Book/Series[not(.=preceding::Book/Series)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createSeriesCompleteItem" >
                    <xsl:with-param name="series"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>

    <!-- Creates the dynamic lists for complete series.
       -
       - A Complete Series:
       -     has more or equal comics than the SeriesCount and more than 12 comics
       -     or has been marked with SeriesComplete
       -
       - @param series {string} Series name
       -->
    <xsl:template name="createSeriesCompleteItem">
        <xsl:param name="series" />
        <xsl:if test="(count(//Book[Series=$series]) > 1 and count(//Book[Series=$series])>=number(../Count) and ../Count > 12) or (../SeriesComplete='Yes' and number(../Count)>12 )">
            <xsl:call-template name="createDynamicList">
                <xsl:with-param name="listName"><xsl:value-of select="$series"/></xsl:with-param>
                <xsl:with-param name="matcher">ComicBookSeriesMatcher</xsl:with-param>
                <xsl:with-param name="matchOperator">6</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>





    <!-- Create the Folder for Series/Incomplete -->
    <xsl:template name='createSeriesIncompleteFolder'>
        <xsl:message>SERIES/INCOMPLETE</xsl:message>
        <Items>
            <xsl:for-each select='//Book/Series[not(.=preceding::Book/Series)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createSeriesIncompleteItem" >
                    <xsl:with-param name="series"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>
    <!-- Creates the dynamic lists for incomplete series.
       -
       - An Incomplete Series:
       -     has fewer comics than SeriesCount
       -     SeriesCount is bigger than one
       -     is not marked as Complete
       -
       - @param series {string} Series name
       -->
    <xsl:template name="createSeriesIncompleteItem">
        <xsl:param name="series" />
        <xsl:if test="../Count > count(//Book[Series=$series]) and ../Count>1 and (not(../SeriesComplete) or ../SeriesComplete!='Yes')">
            <xsl:call-template name="createDynamicList">
                <xsl:with-param name="listName"><xsl:value-of select="$series"/></xsl:with-param>
                <xsl:with-param name="matcher">ComicBookSeriesMatcher</xsl:with-param>
                <xsl:with-param name="matchOperator">6</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>





    <!-- Create the Folder for Arcs/Complete -->
    <xsl:template name='createArcsCompleteFolder'>
        <xsl:message>ARCS/COMPLETE</xsl:message>
        <Items>
            <xsl:for-each select='//Book/AlternateSeries[not(.=preceding::Book/AlternateSeries)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createArcsCompleteItem" >
                    <xsl:with-param name="alternateSeries"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>

    <!-- Creates the dynamic lists for complete arcs.
       -
       - A Complete Arc is an arc where the total numbers of books for this series is bigger than AlternateCount
       -
       - @param alternateSeries {string} AlternateSeries lists
       -->
    <xsl:template name="createArcsCompleteItem">
        <xsl:param name="alternateSeries" />
        <xsl:choose>
            <xsl:when test="contains($alternateSeries, ', ')">
                <xsl:call-template name="createArcsCompleteItem">
                    <xsl:with-param name="alternateSeries" select="substring-before($alternateSeries, ', ')" />
                </xsl:call-template>
                <xsl:call-template name="createArcsCompleteItem">
                    <xsl:with-param name="alternateSeries" select="substring-after($alternateSeries, ', ')" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- Check if the series' total is bigger than the total of books we have for that series -->
                <!--       or we don't have information about series' total at all -->
                <xsl:if test="count(//Book[AlternateSeries=$alternateSeries])>=number(../AlternateCount)">
                    <xsl:call-template name="createDynamicList">
                        <xsl:with-param name="listName"><xsl:value-of select="$alternateSeries"/></xsl:with-param>
                        <xsl:with-param name="matcher">ComicBookAlternateSeriesMatcher</xsl:with-param>
                        <xsl:with-param name="matchOperator">6</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>





    <!-- Creates the Folder for Arcs/Incomplete -->
    <xsl:template name='createArcsIncompleteFolder'>
        <xsl:message>ARCS/INCOMPLETE</xsl:message>
        <Items>
            <xsl:for-each select='//Book/AlternateSeries[not(.=preceding::Book/AlternateSeries)]'>
                <xsl:sort select="."/>

                <xsl:call-template name="createArcsIncompleteItem" >
                    <xsl:with-param name="alternateSeries"><xsl:value-of select="."/></xsl:with-param>
                </xsl:call-template>

            </xsl:for-each>
        </Items>
    </xsl:template>

    <!-- Creates the dynamic lists for incomplete arcs.
       -
       - An Incomplete Arc is an arc where the series' total is bigger than the total of books we have for that series,
       - or we don't have information about series' total at all
       -
       - Given an AlternateSeries list, this template creates a dynamic list for each item in the list:
       -   'The Deep, Batman: Reborn' -> lists for 'The Deep' and 'Batman: Reborn'
       -   'Prodigal' -> One list created for 'Prodigal'
       -
       - @param alternateSeries {string} AlternateSeries lists
       -->
    <xsl:template name="createArcsIncompleteItem">
        <xsl:param name="alternateSeries" />
        <xsl:choose>
            <xsl:when test="contains($alternateSeries, ', ')">
                <xsl:call-template name="createArcsIncompleteItem">
                    <xsl:with-param name="alternateSeries" select="substring-before($alternateSeries, ', ')" />
                </xsl:call-template>
                <xsl:call-template name="createArcsIncompleteItem">
                    <xsl:with-param name="alternateSeries" select="substring-after($alternateSeries, ', ')" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- Check if the series' total is bigger than the total of books we have for that series -->
                <!--       or we don't have information about series' total at all -->
                <xsl:if test="number(../AlternateCount)>count(//Book[contains(AlternateSeries, $alternateSeries)]) or not(../AlternateCount)">
                    <xsl:call-template name="createDynamicList">
                        <xsl:with-param name="listName"><xsl:value-of select="$alternateSeries"/></xsl:with-param>
                        <xsl:with-param name="matcher">ComicBookAlternateSeriesMatcher</xsl:with-param>
                        <xsl:with-param name="matchOperator">6</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!--
       - Creates a DynamicList.
       -
       - @param listName {string} List name
       - @param matcher {string} (Optional) Matcher to use, defaults to 'ComicBookSeriesMatcher'. The other possible
       -                         values is 'ComicBookAlternateSeriesMatcher'
       - @param matchOperator {number} (Optional) Operator to use: 0=IS, 6=LIST CONTAINS, defaults to 0
       -->
    <xsl:template name="createDynamicList">
        <xsl:param name="listName">-</xsl:param>
        <xsl:param name="matcher">ComicBookSeriesMatcher</xsl:param>
        <xsl:param name="matchOperator">0</xsl:param>

        <xsl:choose>
            <!-- Try to reuse old list, if present -->
            <xsl:when test='//Items/Item[@Name=$listName]//ComicBookMatcher[@*=$matcher]'>
                <xsl:message>   [OLD] <xsl:value-of select="$listName"/></xsl:message>
                <!--TODO Investigate how to do this using '.' instead $listName-->
                 <xsl:copy-of select='(//Items/Item[@Name=$listName])[1]'/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:message>   [NEW] <xsl:value-of select="$listName"/></xsl:message>
                <Item xsi:type="ComicSmartListItem" Name="{$listName}">
                    <Matchers>
                        <ComicBookMatcher xsi:type="{$matcher}">
                            <xsl:if test="number($matchOperator)>0">
                                <xsl:attribute name="MatchOperator"><xsl:value-of select="$matchOperator"/></xsl:attribute>
                            </xsl:if>

                            <MatchValue><xsl:value-of select="$listName"/></MatchValue>
                        </ComicBookMatcher>
                    </Matchers>
                </Item>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- This is an identity template - it copies everything that doesn't match another template -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>


    <xsl:output method="xml"/>

</xsl:stylesheet>